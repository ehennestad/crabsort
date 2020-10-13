%                 _                    _   
%   ___ _ __ __ _| |__  ___  ___  _ __| |_ 
%  / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
% | (__| | | (_| | |_) \__ \ (_) | |  | |_ 
%  \___|_|  \__,_|_.__/|___/\___/|_|   \__|
%
% removes means a given channel  

function removeMean(self, channel)


arguments
	self (1,1) crabsort
	channel (1,1) double
end

if strcmp(self.common.data_channel_names{channel},'temperature')
	return
end

only_here = logical(self.mask(:,channel));

self.raw_data(only_here,channel) = self.raw_data(only_here,channel) - mean(self.raw_data(only_here,channel));


if ~isfield(self.handles,'ax')
	return
end

if isempty(self.handles.ax) 
	return
end
if ~isfield(self.handles.ax,'data')
	return
end

% update the YData if need be
if ~isa(self.handles.ax.data(channel),'matlab.graphics.chart.primitive.Line')
	return
end

a = find(self.time >= self.handles.ax.data(channel).XData(1),1,'first');
z = find(self.time <= self.handles.ax.data(channel).XData(end),1,'last');
self.handles.ax.data(channel).YData = self.raw_data(a:z,channel);
