%                 _                    _   
%   ___ _ __ __ _| |__  ___  ___  _ __| |_ 
%  / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
% | (__| | | (_| | |_) \__ \ (_) | |  | |_ 
%  \___|_|  \__,_|_.__/|___/\___/|_|   \__|
%
% updates various elements when a new channel is selected


function updateControlsOnChannelChange(self)

if self.verbosity > 5
    cprintf('green','\n[INFO] ')
    cprintf('text',[mfilename ' called'])
end

if ~isfield(self.handles,'ax')
	return
end

if isempty(self.pref)
    return
end

value = self.channel_to_work_with;


% highlight the currently chosen channel
for i = 1:length(self.handles.ax.ax)

    self.handles.ax.ax(i).YColor = 'k';
    self.handles.ax.channel_label_chooser(i).ForegroundColor = [0 0 0];
    self.handles.ax.recording(i).Visible = 'off';

end
self.handles.ax.ax(value).YColor = 'r';
self.handles.ax.channel_label_chooser(value).ForegroundColor = [1 0 0];
self.handles.ax.ax(value).GridColor = [.15 .15 .15];

if isempty(value)
    % no channel chosen, show all channels
    for i = 1:length(self.handles.ax.ax)
        self.handles.ax.data(i).Color = [self.handles.ax.data(i).Color(1:3) 1];
    end
else
    % make all other channels semi-transparent
    for i = 1:length(self.handles.ax.ax)
        self.handles.ax.data(i).Color = [self.handles.ax.data(i).Color(1:3) self.pref.data_opacity];
    end
    self.handles.ax.data(value).Color = [self.handles.ax.data(value).Color(1:3) 1];
end

% disable allowing automation on this channel
disableMenuItem(vertcat(self.handles.menu_name.Children),'Text','Run on this channel');

% if the name for this channel is unset, disable
% everything
if length(self.common.data_channel_names) < self.channel_to_work_with || strcmp(self.common.data_channel_names{self.channel_to_work_with},'???') || isempty(self.common.data_channel_names{self.channel_to_work_with})

    if self.verbosity > 5
        cprintf('green','\n[INFO] ')
        cprintf('text','the name for this channel is unset')
    end

    %  
    % disable everything and force user to name the channel

    % disable everything
    disable(self.handles.spike_detection_panel);
    disable(self.handles.dim_red_panel);
    disable(self.handles.cluster_panel);


else

    if self.verbosity > 5
        cprintf('green','\n[INFO] ')
        cprintf('text','This channel is named')
    end

    % lots of possibilities here 
    % enable everything
    enable(self.handles.spike_detection_panel);
    enable(self.handles.dim_red_panel);
    enable(self.handles.cluster_panel);

    % if it's intracellular
    temp = isstrprop(self.common.data_channel_names{value},'upper');
    if any(temp)
        new_max = diff(self.handles.ax.ax(value).YLim)/2;
        self.handles.prom_ub_control.String = mat2str(new_max);
        self.handles.spike_prom_slider.Max = new_max;
        self.handles.spike_prom_slider.Value = new_max;
    else
        % use custom Y-lims if we have it --
        % unless it's an intracellular channel, in which case
        % we ignore it
        if ~isempty(self.channel_ylims) && ~isempty(self.channel_ylims(value)) && self.channel_ylims(value) > 0
            yl = self.channel_ylims(value);
            self.handles.ax.ax(value).YLim = [-yl yl];
        end
    end

    % if this channel has automate_info
    % enable automation on this channel 

    if length(self.common.automate_info) >= self.channel_to_work_with && ~isempty(self.common.automate_info(self.channel_to_work_with).operation)

        enableMenuItem(vertcat(self.handles.menu_name.Children),'Text','Run on this channel');
        enableMenuItem(vertcat(self.handles.menu_name.Children),'Text','Delete automate info for this channel');

        % this channel has automation info
        % automatically turn "watch me" off
        m = vertcat(self.handles.menu_name.Children);
        for i = 1:length(m)
            if strcmp(m(i).Text,'Watch me')
                m(i).Checked = 'off';
                self.watch_me = false;
                self.handles.ax.recording(value).Visible = 'off';
            end
        end
    else
        % this channel has no automation info
        disableMenuItem(vertcat(self.handles.menu_name.Children),'Text','Run on this channel');
        disableMenuItem(vertcat(self.handles.menu_name.Children),'Text','Delete automate info for this channel');


        s = self.getSpikesOnThisNerve;
        if ~any(s)
            % this channel has no automaton info, and has no spikes
            % automatically turn "watch_me" on
            
            m = vertcat(self.handles.menu_name.Children);
            for i = 1:length(m)
                if strcmp(m(i).Text,'Watch me')
                    m(i).Checked = 'on';
                    self.handles.ax.recording(value).Visible = 'on';
                    self.watch_me = true;
                end
            end

        end

    end
end

% reset the manual_override to off
self.handles.mode_off.Value = 1;

% if this channel has sorted spike, enable the manual override 
if self.channel_stage(self.channel_to_work_with) > 2
    enable(self.handles.manual_panel)

    % update the neuron names if extracellular
    temp = isstrprop(self.common.data_channel_names{self.channel_to_work_with},'upper');
    if ~any(temp)
        neuron_names = self.nerve2neuron.(self.common.data_channel_names{self.channel_to_work_with});
        self.handles.new_spike_type.String = neuron_names;
    else
        self.handles.new_spike_type.String = self.common.data_channel_names{self.channel_to_work_with};
    end
    
else
    disable(self.handles.manual_panel)
end