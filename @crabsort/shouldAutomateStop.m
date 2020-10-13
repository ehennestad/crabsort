function TF = shouldAutomateStop(self, channel)

arguments
	self (1,1) crabsort
	channel (1,1) double
end

TF = false;

if self.automate_action == crabsort.automateAction.none
	TF = true;
	return
end

M = self.handles.menu_name(4).Children;
Checked = {M.Checked};

% should stop if artifacts are marked
if strcmp(Checked{strcmp({M.Text},'Stop if artifacts are marked')},'on')
	if  min(min(self.mask)) == 0
		TF = true;
		return
	end
end

% should stop when data exceeds YLim
if strcmp(Checked{strcmp({M.Text},'Stop when data exceeds YLim')},'on')

	if ~isempty(channel)

		YLim = self.handles.ax.ax(channel).YLim;
		if max(self.raw_data(:,channel)) > YLim(2)
			TF = true;
			return
		end

		if min(self.raw_data(:,channel)) < YLim(1)
			TF = true;
			return
		end

	else
		% stop if data exceeds Ylim in any channel
		errordlg(err.message,'This case has not been coded yet.')
		if self.debug_mode
			keyboard
		else
			error('FATAL ERROR')
		end

	end

end


% stop when uncertain
if strcmp(Checked{strcmp({M.Text},'Stop when uncertain')},'on')

	if ~isempty(self.channel_to_work_with)
		channel = self.channel_to_work_with;

		if ~isempty(self.handles.ax.uncertain_spikes(channel).XData) && ~any(isnan(self.handles.ax.uncertain_spikes(channel).XData))

			disp('Stopping because some uncertain spikes exist')
			TF = true;
			return
		end



	end

end