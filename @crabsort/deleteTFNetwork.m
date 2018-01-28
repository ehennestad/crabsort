%                 _                    _   
%   ___ _ __ __ _| |__  ___  ___  _ __| |_ 
%  / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
% | (__| | | (_| | |_) \__ \ (_) | |  | |_ 
%  \___|_|  \__,_|_.__/|___/\___/|_|   \__|
%
% deletes the cached TF network file, if any 
% for the current channel
function deleteTFNetwork(self,~,~)


if length(self.tf_model_name) < self.channel_to_work_with
	return
end

try
	rmdir(joinPath(self.tf_folder,'models',self.tf_model_name{self.channel_to_work_with}),'s')
catch
end