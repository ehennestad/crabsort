%                 _                    _   
%   ___ _ __ __ _| |__  ___  ___  _ __| |_ 
%  / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
% | (__| | | (_| | |_) \__ \ (_) | |  | |_ 
%  \___|_|  \__,_|_.__/|___/\___/|_|   \__|
%
% saves data in a .crabsort file 

function saveData(self)


% early escape
if isempty(self.time) 
    return
end

% saveData saves data to two different locations:
% local data that pertains to this file in a .crabsort file
% and common data that eprtains to all files in this folder
% to a file called crabsort.common in that folder 


file_name = pathlib.join(self.path_name, [self.file_name '.crabsort']);
common_name = pathlib.join(self.path_name, 'crabsort.common');


% generate ignore_section from the mask
global_mask = max(self.mask,[],2);
[ons, offs]=veclib.computeOnsOffs(global_mask);
self.ignore_section.ons = ons;
self.ignore_section.offs = offs;

crabsort_obj = crabsort(false);

fn = properties(self);

for i = 1:length(fn)
	this_prop = fn{i};
	if any(strcmp(this_prop,self.unsaved_variables))
		continue
	end

	crabsort_obj.(this_prop) = self.(this_prop);

end

save(file_name,'crabsort_obj','-v7.3')




% now save the common items
common = self.common;
save(common_name,'common','-v7.3')

