%                 _                    _   
%   ___ _ __ __ _| |__  ___  ___  _ __| |_ 
%  / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
% | (__| | | (_| | |_) \__ \ (_) | |  | |_ 
%  \___|_|  \__,_|_.__/|___/\___/|_|   \__|
%
% modifies data based on mouse clicks 
function modify(self,p)

if self.verbosity > 9
	disp(mfilename)
end



channel = self.channel_to_work_with;


% figure out wheter we are right or left clicking
switch self.handles.main_fig.SelectionType
case 'normal'
    self.leftClickCallback(p);
case 'alt'
	if self.channel_stage(channel) < 3
		return
	end
    self.rightClickCallback(p);

case 'open'
	% double click, ignore
	return
otherwise
	if self.debug_mode
		keyboard
	else
		error('Unknown mouse action')
	end
    
end

