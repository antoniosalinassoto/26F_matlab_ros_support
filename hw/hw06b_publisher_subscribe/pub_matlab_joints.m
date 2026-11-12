function pub_matlab_joints(~,message)
% Display the Joint States up to 2 d.p. using fprintf in the order below:
% Namely:{"sh_lift", "sh_pan", "elbow", "w1", "w2", "w3", "f1", "f2"};

    % BEGIN_YOUR_CODE 
   target_names = ["sh_lift", "sh_pan", "elbow", "w1", "w2", "w3", "f1", "f2"];
   msg_names = string(message.Name);
   for i = 1:length(target_names)
  index = find(msg_names == target_names(i));
      if ~isempty(index)
          fprintf('%.2f ', message.Position(index));
      end
   end
fprintf('\n');
    % END_YOUR_CODE
end
