import casadi as ca
import numpy as np
import time

class MPCController:
    def __init__(self, N=20, dt=0.01, puck_radius = 0.05, mallet_radius= 0.07,
                  home_pos = np.array([0.5, 0.2]), goal_pos = np.array([0.5, 2.0]),
                  m_puck = 0.02, m_hover = 0.146):
        self.N = N  
        self.opti = ca.Opti()

        self.dt = dt
        self.home_pos = ca.vertcat(home_pos[0], home_pos[1])
        self.goal_pos = ca.vertcat(goal_pos[0], goal_pos[1])

        self.puck_radius = puck_radius
        self.mallet_radius = mallet_radius
        self.max_speed = 1.5
        
        # Hovercraft variables 
        self.X = self.opti.variable(4, self.N + 1)
        self.U = self.opti.variable(2, self.N)
        self.x0_param = self.opti.parameter(4)
        self.strike_target = self.opti.parameter(2)

        # Puck parameter
        self.puck_pos_param = self.opti.parameter(4)
        
        # Formulation -------------------------------------
        obj = 0

        puck_y = self.puck_pos_param[1]
        puck_vy = self.puck_pos_param[3]

        direction_sign = ca.sign(self.goal_pos[1] - self.home_pos[1]) 
        midline_y = (self.home_pos[1] + self.goal_pos[1]) / 2

        dist_from_mid_to_puck = direction_sign * (midline_y - puck_y)
        velocity_toward_goal = direction_sign * puck_vy
        is_on_our_side = 0.5 * (1 + ca.tanh(10 * dist_from_mid_to_puck))
        puck_is_retreating = 0.5 * (1 + ca.tanh(10 * velocity_toward_goal))
        is_far = 1 - is_on_our_side
        is_away = ca.fmax(is_far, puck_is_retreating)

        for k in range(self.N):
            # dynamics
            st_next = self.X[:, k] + ca.vertcat(self.X[2:, k], self.U[:, k]) * dt
            self.opti.subject_to(self.X[:, k+1] == st_next)

            # maximum velocity constraints
            vx_k = self.X[2, k]
            vy_k = self.X[3, k]
            self.opti.subject_to(vx_k**2 + vy_k**2 <= self.max_speed**2)

            # come home when the puck is far away
            obj += is_away* 100 * ca.sumsqr(self.X[:2, k]- self.home_pos)
        

        momentum_rewards = 0
        distance_rewards = 0

        p_pos_k = self.puck_pos_param[:2]
        p_vel_k = self.puck_pos_param[2:]
        for k in range(self.N):
            # puck trajectory prediction ---------------------------------------
            p_pos_k += p_vel_k * self.dt
            
            # left wall
            is_outside_left = p_pos_k[0] < self.puck_radius
            p_pos_k[0] = ca.if_else(is_outside_left, 2 * self.puck_radius - p_pos_k[0], p_pos_k[0])
            p_vel_k[0] = ca.if_else(is_outside_left, -p_vel_k[0] * 0.8, p_vel_k[0])
            
            # right wall
            is_outside_right = p_pos_k[0] > 1.1 - self.puck_radius
            p_pos_k[0] = ca.if_else(is_outside_right, 2 * (1.1 - self.puck_radius) - p_pos_k[0], p_pos_k[0])
            p_vel_k[0] = ca.if_else(is_outside_right, -p_vel_k[0] * 0.8, p_vel_k[0])

            p_vel_k *= 0.993 # friction

            vec_to_goal_k = self.goal_pos - p_pos_k
            unit_dir_k = vec_to_goal_k / (ca.norm_2(vec_to_goal_k) + 1e-6)
            strike_spot_k = p_pos_k - unit_dir_k * (self.puck_radius + self.mallet_radius)

            dist_sq_k = ca.sumsqr(self.X[:2, k] - strike_spot_k)

            width_k = 0.3 # < 1
            width_d = 0.4
            weight_k = ca.exp(-dist_sq_k / (width_k**2))
            weight_d = ca.exp(-dist_sq_k / (width_d**2))
 
            distance_rewards += weight_d * dist_sq_k

            # incentivising the momentum transfer in the goal direction
            v_m_k = self.X[2:, k]
            v_m_proj = ca.dot(v_m_k, unit_dir_k)
            v_p_proj = ca.dot(p_vel_k, unit_dir_k) # more negative the better already aligned with the goal
            v_p_after = v_m_proj - v_p_proj # momentum component in the goal direction, v_final for mallet is 0 for approximation
            momentum_rewards += weight_k * v_p_after

        # visualisation only of the strike target
        vec_to_goal_N = self.goal_pos - p_pos_k
        unit_dir_N = vec_to_goal_N / (ca.norm_2(vec_to_goal_N) + 1e-6)
        strike_spot_N = p_pos_k - unit_dir_N * (self.puck_radius + self.mallet_radius)
        self.strike_target = strike_spot_N

        # penalising control
        control_effort = 0.01 * ca.sumsqr(self.U)   

        # tuning and summing all objectives
        obj += distance_rewards - 100 * momentum_rewards + control_effort
        
        self.opti.minimize(obj)

        self.opti.subject_to(self.X[:, 0] == self.x0_param)

        # Bound X (Left and Right walls)
        self.opti.subject_to(self.opti.bounded(
            0.01, 
            self.X[0, :], 
            1.1 - 0.03))
        
        opts = {"ipopt.print_level": 0, "print_time": 0}
        self.opti.solver("ipopt", opts)

    def get_action(self, mallet_state, puck_state):
        self.opti.set_value(self.x0_param, mallet_state)
        self.opti.set_value(self.puck_pos_param, puck_state)
        
        try:
            sol = self.opti.solve()
            u_next = sol.value(self.U[:, 0])
            x_pred = sol.value(self.X[0, :])
            y_pred = sol.value(self.X[1, :])
            self.opti.set_initial(sol.value_variables()) 

            return u_next, (x_pred, y_pred), sol.value(self.strike_target)
        except:
            # If solver fails, return zeros and empty trajectory
            return np.array([0.0, 0.0]), (None, None), None