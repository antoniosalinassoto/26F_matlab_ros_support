function hw_06b_ros_pub_sub()
    %% Close ROS to ensure fresh start
    clear;
    rosshutdown;

    %% 01Start ROS via rosinit
    % BEGIN_YOUR_CODE 
    rosinit
    % END_YOUR_CODE
    
    %% 02 Start Robot Class Handle
    % BEGIN_YOUR_CODE 
    ros_handle = ros_class_handle();
    % END_YOUR_CODE
   
    %% 03 Load Joint Angle Data
    % BEGIN_YOUR_CODE 
   joint_data = load_top_pick_joint_data();
    % END_YOUR_CODE

    %% 04 Compute ctraj goals for your top pick using panda_handa for IKs and your output for joint angle data
    % BEGIN_YOUR_CODE 
    goal_poses = top_pick(joint_data, ros_handle.robot, 'panda_hand'):
    % END_YOUR_CODE

    %% 05 Create a subscriber that receives /matlab_joint_states and pubishes ros-based /joint_states
    % Ensure this is done inside ros_class_handle

    %% 06 Compute ctraj trajectory and publish to /matlab_joint_states with sensor_msgs/JointStates via traj_gen
    % BEGIN_YOUR_CODE 
    ik = inverseKinematics('RigidBodyTree', ros_handle.robot);
    q_guess = joint_data(1, :);
    traj_gen(goal_poses, ros_handle.robot, ik, q_guess);
    % END_YOUR_CODE  
