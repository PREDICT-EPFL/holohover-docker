import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from mpc_controller import MPCController
from motion_planner import MotionPlanner

class AirHockeySim:
    def __init__(self):
        # Table Dimensions (m)
        self.width = 1.1
        self.height = 2.2
        self.dt = 0.01
        self.home_pos = np.array([0.55, 0.25])
        self.goal_pos = np.array([0.55, 2.0])
        
        # Physics Parameters
        self.puck_radius = 0.05
        self.mallet_radius = 0.07
        self.friction = 0.993  # Velocity multiplier per step
        self.restitution = 0.8 # Bounce elasticity
        
        # State: [x, y, vx, vy]
        self.puck_state = np.array([0.5, 1.5, 3, -5])
        self.mallet_state = np.array([0.5, 0.2, 0.0, 0.0])
        self.opponent_state = np.array([0.5, 1.8, 0.0, 0.0])

        self.m_mallet = 0.146
        self.m_puck = 0.02
        
    def step(self, mallet_accel, opponent_accel):
        """
        Update physics. 
        mallet_accel: [ax, ay] provided by your controller
        """
        # 1. Update Mallet (Double Integrator)
        self.mallet_state[2:] += mallet_accel * self.dt
        self.mallet_state[:2] += self.mallet_state[2:] * self.dt

        self.opponent_state[2:] += opponent_accel * self.dt
        self.opponent_state[:2] += self.opponent_state[2:] * self.dt

        self.handle_mallet_walls(self.mallet_state)
        self.handle_mallet_walls(self.opponent_state)
        
        # 2. Update Puck (Passive)
        self.puck_state[:2] += self.puck_state[2:] * self.dt
        self.puck_state[2:] *= self.friction
        
        # 3. Wall Collisions (Puck)
        for i in range(2): # x and y axes
            limit = self.width if i == 0 else self.height
            if self.puck_state[i] < self.puck_radius:
                self.puck_state[i] = self.puck_radius
                self.puck_state[i+2] *= -self.restitution
            elif self.puck_state[i] > limit - self.puck_radius:
                self.puck_state[i] = limit - self.puck_radius
                self.puck_state[i+2] *= -self.restitution

        # 4. Mallet-Puck Collision
        dist = np.linalg.norm(self.mallet_state[:2] - self.puck_state[:2])
        min_dist = self.puck_radius + self.mallet_radius
        
        if dist < min_dist:
            # Normal vector of collision
            normal = (self.puck_state[:2] - self.mallet_state[:2]) / dist
            # Push puck out of mallet to prevent overlap
            overlap = min_dist - dist
            self.puck_state[:2] += normal * overlap
            # Simple elastic impulse reflection
            relative_vel = self.puck_state[2:] - self.mallet_state[2:]
            mass_ratio = (2*self.m_mallet) / (self.m_puck + self.m_mallet)
            mallet_mass_ratio = (2 * self.m_puck) / (self.m_puck + self.m_mallet)
            # TODO: add hovercraft response to the collision
            vel_along_normal = np.dot(relative_vel, normal)
            if vel_along_normal < 0:
                self.puck_state[2:] -= mass_ratio * vel_along_normal * normal
                self.mallet_state[2:] += mallet_mass_ratio * vel_along_normal * normal
                print("Puck collision with vx = ", self.puck_state[2], "| vy = ", self.puck_state[3])

        # 4. Mallet-Puck Collision
        dist = np.linalg.norm(self.opponent_state[:2] - self.puck_state[:2])
        min_dist = self.puck_radius + self.mallet_radius
        
        if dist < min_dist:
            # Normal vector of collision
            normal = (self.puck_state[:2] - self.opponent_state[:2]) / dist
            # Push puck out of mallet to prevent overlap
            overlap = min_dist - dist
            self.puck_state[:2] += normal * overlap
            # Simple elastic impulse reflection
            relative_vel = self.puck_state[2:] - self.opponent_state[2:]
            mass_ratio = (2*self.m_mallet) / (self.m_puck + self.m_mallet)
            vel_along_normal = np.dot(relative_vel, normal)
            if vel_along_normal < 0:
                self.puck_state[2:] -= mass_ratio * vel_along_normal * normal
                print("Puck collision with vx = ", self.puck_state[2], "| vy = ", self.puck_state[3])

    def handle_mallet_walls(self, state):
        # --- X-axis (Same for both sides) ---
        if state[0] < self.mallet_radius:
            state[0] = self.mallet_radius
            state[2] *= -0.5
        elif state[0] > self.width - self.mallet_radius:
            state[0] = self.width - self.mallet_radius
            state[2] *= -0.5

        # --- Y-axis (Side-Aware) ---
        midline = self.height / 2
        
        # Check if this state belongs to the player starting in the top half
        # We can use the current position to guess, or better, identify the mallet.
        if state[1] > midline:
            # TOP PLAYER BOUNDARIES
            # Back wall (Top)
            if state[1] > self.height - self.mallet_radius:
                state[1] = self.height - self.mallet_radius
                state[3] *= -0.5
            # Center line (Bottom for them)
            elif state[1] < midline + self.mallet_radius:
                state[1] = midline + self.mallet_radius
                state[3] *= -0.5
        else:
            # BOTTOM PLAYER BOUNDARIES
            # Back wall (Bottom)
            if state[1] < self.mallet_radius:
                state[1] = self.mallet_radius
                state[3] *= -0.5
            # Center line (Top for them)
            elif state[1] > midline - self.mallet_radius:
                state[1] = midline - self.mallet_radius
                state[3] *= -0.5

# --- Animation & Execution ---
sim = AirHockeySim() 

oppo_home =np.array([0.55, 1.9])
oppo_goal = np.array([0.55, 0.0])
ctrl = MPCController(N=15, dt=0.02, goal_pos=sim.goal_pos, home_pos=sim.home_pos)
ctrl2 = MPCController(N=15, dt=0.02, goal_pos=oppo_goal, home_pos=oppo_home)
#mp = MotionPlanner()


fig, ax = plt.subplots(figsize=(5, 8))
ax.set_xlim(0, sim.width)
ax.set_ylim(0, sim.height)
ax.set_aspect('equal')

puck_circle = plt.Circle(sim.puck_state[:2], sim.puck_radius, color='red', label='Puck')
mallet_circle = plt.Circle(sim.mallet_state[:2], sim.mallet_radius, color='blue', label='Mallet')
oppo_circle = plt.Circle(sim.opponent_state[:2], sim.mallet_radius, color='blue', label='Opponent')
strike_spot_marker = plt.Circle((0, 0), 0.02, color='red', alpha=0.5, label='Aim Point')
ax.add_patch(puck_circle)
ax.add_patch(mallet_circle)
ax.add_patch(oppo_circle)
ax.add_patch(strike_spot_marker)

# --- Setup Prediction Line ---
# Create an empty line object for the prediction
prediction_line, = ax.plot([], [], 'cyan', linestyle='--', alpha=0.6, label='MPC Plan')
oppo_line, = ax.plot([], [], 'cyan', linestyle='--', alpha=0.6, label='MPC Plan (Opponent)')
strike_dots = ax.scatter([], [], c=[], cmap='RdYlGn', s=20)
velocity_text = ax.text(0.05, 0.95, '', transform=ax.transAxes, 
                        fontsize=12, fontweight='bold', color='black',
                        bbox=dict(facecolor='white', alpha=0.7))
# Initializing the arrow with zero length
normal_arrow = ax.quiver(0, 0, 0, 0, color='yellow', 
                         angles='xy', scale_units='xy', scale=1, 
                         width=0.015, label="Impact Normal")

counter = 0
def update(frame):
    global counter
    counter += 1
    # 1. Get Control Input AND Prediction
    u, (x_pred, y_pred), target_spot_1 = ctrl.get_action(sim.mallet_state, sim.puck_state)
    u2, (x_pred2, y_pred2), target_spot2 = ctrl2.get_action(sim.opponent_state, sim.puck_state)
        
    # 2. Step Simulation
    sim.step(u, u2)

    # 3. Update Visuals (Current States)
    puck_circle.center = sim.puck_state[:2]
    mallet_circle.center = sim.mallet_state[:2]
    oppo_circle.center = sim.opponent_state[:2]
    # 4. Update MPC Prediction Line (The path the mallet plans to take)
    if x_pred is not None:
        prediction_line.set_data(x_pred, y_pred)
    if x_pred2 is not None:
        oppo_line.set_data(x_pred2, y_pred2)

    # 5. Update INTERCEPTION WINDOW (The future strike spots)
    spots = []
    margins = []
    N = 10
    dt = 0.02
    
    temp_p_pos = np.copy(sim.puck_state[:2])
    temp_p_vel = np.copy(sim.puck_state[2:])
    
    spots = []
    margins = []

    for k in range(N):
        # 1. Prediction (Apply Friction FIRST to match MPC)
        temp_p_pos += temp_p_vel * dt
        
        # 2. Wall Bounces (Use the exact MPC width: 1.1)
        # Left wall
        if temp_p_pos[0] < sim.puck_radius:
            temp_p_pos[0] = 2 * sim.puck_radius - temp_p_pos[0]
            temp_p_vel[0] *= -0.8 # Match MPC bounce coefficient
        # Right wall
        elif temp_p_pos[0] > 1.1 - sim.puck_radius:
            temp_p_pos[0] = 2 * (1.1 - sim.puck_radius) - temp_p_pos[0]
            temp_p_vel[0] *= -0.8

        temp_p_vel *= 0.993 

        # ... (Strike spot and margin calculation) ...

        # 3. Calculate the "Strike Spot" based on this (potentially reflected) position
        vec_to_goal = sim.goal_pos - temp_p_pos
        dist = np.linalg.norm(vec_to_goal) + 1e-6
        unit_dir = vec_to_goal / dist
        
        spot_k = temp_p_pos - unit_dir * (sim.mallet_radius + sim.puck_radius)
        spots.append(spot_k)
        
        # 4. Reachability Margin
        dist_to_spot = np.linalg.norm(sim.puck_state[:2] - spot_k)
        margin = ctrl.max_speed * (k * dt) - dist_to_spot
        margins.append(margin)
    
    # Update the scatter plot
    strike_dots.set_offsets(np.array(spots))
    strike_dots.set_array(np.array(margins)) # This triggers the color map (Red to Green)
    strike_spot_marker.center = target_spot_1
    vx, vy = sim.mallet_state[2:]
    speed = np.sqrt(vx**2 + vy**2)
    
    # Update the text content
    velocity_text.set_text(f'Hover Speed: {speed:.2f} m/s')

    return [puck_circle, mallet_circle, oppo_circle, prediction_line, oppo_line, strike_dots, strike_spot_marker, velocity_text]

ani = FuncAnimation(fig, update, frames=200, interval=20, blit=True)
plt.show()