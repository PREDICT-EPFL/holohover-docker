import matplotlib.pyplot as plt
import matplotlib.animation as animation
import csv
import glob
import subprocess
import sys

import os
from datetime import datetime

def get_latest_modified_directory(path):
    # Get a list of all directories in the specified path
    directories = [d for d in os.listdir(path) if os.path.isdir(os.path.join(path, d))]
    
    # If there are no directories, return None
    if not directories:
        return None
    
    # Create a list of tuples (directory, last_modified_time)
    directories_with_time = []
    for directory in directories:
        dir_path = os.path.join(path, directory)
        last_modified_time = os.path.getmtime(dir_path)
        directories_with_time.append((directory, last_modified_time))
    
    # Sort the directories by last modified time in descending order
    directories_with_time.sort(key=lambda x: x[1], reverse=True)
    
    # Return the name of the directory with the most recent modification time
    return directories_with_time[0][0]



# Function to parse the CSV and extract trajectories for agent 0
def parse_csv_for_agent0(filename, N):
    trajectories = []

    with open(filename, newline='') as csvfile:
        reader = csv.reader(csvfile)

        for row in reader:
            iteration = int(row[0])
            
            # First 126 elements after the iteration number
            data = row[1:(6*(N+1)+1)]

            # Extract positions (pos_x, pos_y)
            pos_x = [float(data[i * 6]) for i in range(N+1)]
            pos_y = [float(data[i * 6 + 1]) for i in range(N+1)]

            trajectories.append((pos_x, pos_y))

    return trajectories

# Function to parse the CSV and extract trajectories for other agents
def parse_csv_for_other_agents(filename, N):
    trajectories = []

    with open(filename, newline='') as csvfile:
        reader = csv.reader(csvfile)

        for row in reader:
            iteration = int(row[0])
            
            # Offset by 126 elements for the first agent's data
            data = row[(6*(N+1)+1):]

            # Extract positions (pos_x, pos_y)
            pos_x = [float(data[i * 6]) for i in range(N+1)]
            pos_y = [float(data[i * 6 + 1]) for i in range(N+1)]

            trajectories.append((pos_x, pos_y))

    return trajectories

# Function to update the plot
def update(num, all_trajectories, lines, current_positions, first_states, history_lines, histories, time_text, sampling_interval, history_length):
    for agent_idx, trajectories in enumerate(all_trajectories):
        if num < len(trajectories):
            pos_x, pos_y = trajectories[num]
            lines[agent_idx].set_data(pos_x, pos_y)
            current_positions[agent_idx].set_data(pos_x[0], pos_y[0])
            first_states[agent_idx].set_data(pos_x[0], pos_y[0])

            # Update the history of the first state
            histories[agent_idx].append((pos_x[0], pos_y[0]))
            if len(histories[agent_idx]) > history_length:
                histories[agent_idx].pop(0)
            
            # Plot the history line
            history_x = [h[0] for h in histories[agent_idx]]
            history_y = [h[1] for h in histories[agent_idx]]
            history_lines[agent_idx].set_data(history_x, history_y)
    
    time_text.set_text(f'Time: {num * sampling_interval:.2f}s')
    return lines + current_positions + first_states + history_lines + [time_text]

# Main function
def main():

    N = int(sys.argv[1])
    sampling_interval = float(sys.argv[2]) 

    print("running script for N ", N, "sampling interval: ", sampling_interval)

    # Take the last run experiment
    path_to_check = '/home/andrea/holohover-docker/log'
    directory = get_latest_modified_directory(path_to_check)
    # print(f"The latest modified directory is: {directory}")
    
    # Define the specific file patterns or paths for the agents
    file_patterns = [
        '/home/andrea/holohover-docker/log/' + directory + '/*/log/dmpc_sol_log_agent0_*.csv',
        '/home/andrea/holohover-docker/log/' + directory + '/*/log/dmpc_sol_log_agent1_*.csv',
        '/home/andrea/holohover-docker/log/' + directory + '/*/log/dmpc_sol_log_agent2_*.csv',
        '/home/andrea/holohover-docker/log/' + directory + '/*/log/dmpc_sol_log_agent3_*.csv'
    ]

    all_trajectories = []
    for pattern in file_patterns:
        files = glob.glob(pattern)
        if not files:
            print(f"No files found for pattern: {pattern}")
            continue

        file = files[0]  # Assuming one file per pattern
        if "agent0" in file:
            trajectories = parse_csv_for_agent0(file, N)
        else:
            trajectories = parse_csv_for_other_agents(file, N)
        all_trajectories.append(trajectories)

    fig, ax = plt.subplots()

    lines = []
    current_positions = []
    first_states = []
    history_lines = []
    histories = []
    colors = ['r', 'g', 'b', 'm']  # Different colors for different agents

    num_agents = len(all_trajectories)

    # Initialize lines for each agent
    for i in range(num_agents):
        color = colors[i % len(colors)]  # Cycle through colors if there are more agents than colors
        line, = ax.plot([], [], 'o-', lw=2, color=color, label=f'Agent {i}')
        current_position, = ax.plot([], [], 'o', markersize=8, color=color)
        first_state, = ax.plot([], [], 'o', markersize=8, color='k')  # First state in black
        history_line, = ax.plot([], [], '-', lw=2, color='gray')  # History line in gray
        histories.append([])

        lines.append(line)
        current_positions.append(current_position)
        first_states.append(first_state)
        history_lines.append(history_line)

    ax.set_xlim(-1.1, 1.1)  # Updated x-axis limits based on your data
    ax.set_ylim(-0.55, 0.55)  # Updated y-axis limits based on your data
    ax.set_xlabel('Position X')
    ax.set_ylabel('Position Y')
    ax.set_title('Trajectories Animation')
    ax.legend()

    history_length = int(20 / sampling_interval)  # 1 second of history

    time_text = ax.text(0.02, 0.95, '', transform=ax.transAxes)

    num_frames = max(len(trajectories) for trajectories in all_trajectories)

    ani = animation.FuncAnimation(fig, update, frames=num_frames, 
                                  fargs=(all_trajectories, lines, current_positions, first_states, history_lines, histories, time_text, sampling_interval, history_length), 
                                  interval=sampling_interval * 1000, blit=True)

    plt.show()

if __name__ == "__main__":
    main()
