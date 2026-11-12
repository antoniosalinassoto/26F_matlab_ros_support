function traj_gen(ctraj_pts, robot_handle, robot_ik_num, q_guess)
%--------------------------------------------------------------------------
% Top-Pick Skill
% Create a trajectory based on ctraj waypoints that can be expanded via 
% ctraj and inverse kinematics.
%
% Inputs:
% ctraj1: [double]  The 4x4x5 matrix composed of 5 4x4 matrices corresponding 
%                   to the poses of the 5 way-points.
%----------------------------------------------------------------------
    % BEGIN_YOUR_CODE 
    %% Initialize homogeneous transform matrix
    %% Generate cartesian trajectories across way points:
    %% Generate the joint angle configurations for all of these steps. Also publish and display them.
    num_pts = size(ctraj_pts, 3);
    steps_per_segment = 20;
   total_steps = (num_pts - 1) * steps_per_segment;
   T_traj = zeros(4, 4, total_steps);
   step_idx = 1;
   for i = 1:(num_pts - 1)
       T_start = ctraj_pts(:, :, i);
       T_end   = ctraj_pts(:, :, i+1);
       T_traj(:, :, step_idx:(step_idx + steps_per_segment - 1)) = ctraj(T_start, T_end, steps_per_segment);
       step_idx = step_idx + steps_per_segment;
   end
   joint_pub = rospublisher('/matlab_joint_states', 'sensor_msgs/JointState');
   joint_msg = rosmessage(joint_pub);
   warning('ROS is not initialized. Run rosinit to publish data.');
   joint_pub = [];
   ee_name = robot_handle.BodyNames{end};
   weights = [1 1 1 1 1 1]; 
   current_q_guess = q_guess;
   figure('Name', 'Top-Pick Trajectory Execution');

   for i = 1:total_steps
       T_target = T_traj(:, :, i);
       [q_sol, ~] = robot_ik_num(ee_name, T_target, weights, current_q_guess);
       if isstruct(q_sol)
           joint_positions = [q_sol.JointPosition];
           joint_names = {q_sol.JointName};
       else
           joint_positions = q_sol;
           joint_names = strcat('joint_', string(1:length(joint_positions))); 
       end
       current_q_guess = q_sol;
       if ~isempty(joint_pub)
           joint_msg.Header.Stamp = rostime('now');
           joint_msg.Name = joint_names;
           joint_msg.Position = joint_positions;
           send(joint_pub, joint_msg);
       end
       show(robot_handle, q_sol, 'PreservePlot', false, 'Frames', 'off');
       title(sprintf('Publishing Trajectory: Step %d of %d', i, total_steps));
    % END_YOUR_CODE
end
