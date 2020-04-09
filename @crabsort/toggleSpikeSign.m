%                 _                    _   
%   ___ _ __ __ _| |__  ___  ___  _ __| |_ 
%  / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
% | (__| | | (_| | |_) \__ \ (_) | |  | |_ 
%  \___|_|  \__,_|_.__/|___/\___/|_|   \__|
%
% flips b/w finding +ve and -ve spikes

function toggleSpikeSign(self,~,~)


if any(isnan(corelib.vectorise(self.sdp)))
	self.sdp = self.sdp.default();
end

self.sdp.spike_sign = logical(self.handles.spike_sign_control.Value);

if self.sdp.spike_sign
	set(self.handles.spike_sign_control,'String','+ve spikes')
else
	set(self.handles.spike_sign_control,'String','-ve spikes')
end

self.common.NNdata(self.channel_to_work_with).sdp.spike_sign = self.sdp.spike_sign;


self.findSpikes;
