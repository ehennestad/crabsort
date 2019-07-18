function ignoreEntireFiles(self, src, ~)

% get all files in this dataset
thisfile = self.file_name;
[~,~,ext]=fileparts(self.file_name);
allfiles = dir([self.path_name filesep '*' ext]);


if any(strfind(src.Text,'BEFORE'))

	for i = 1:length(allfiles)

		if strcmp(allfiles(i).name,thisfile)
			return
		end

		% load the file
		if exist([allfiles(i).folder filesep allfiles(i).name '.crabsort'],'file') == 2

			load([allfiles(i).folder filesep allfiles(i).name '.crabsort'],'-mat')
			crabsort_obj.ignore_section.ons = 1;
			crabsort_obj.ignore_section.offs = crabsort_obj.raw_data_size(1);
			save([allfiles(i).folder filesep allfiles(i).name '.crabsort'],'crabsort_obj')
		end


	end

else
	error('Not coded');

end