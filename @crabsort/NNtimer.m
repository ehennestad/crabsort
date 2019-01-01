%{ 
                _                    _   
  ___ _ __ __ _| |__  ___  ___  _ __| |_ 
 / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
| (__| | | (_| | |_) \__ \ (_) | |  | |_ 
 \___|_|  \__,_|_.__/|___/\___/|_|   \__|
                                         


# NNtimer

**Syntax**

```
C.NNtimer(~,~)
```

**Description**

this function is meant to be run on a timer
it does the following things:

1. update the accuracy displays on every channel
2. trains a network if it needs to be

%}


function NNtimer(self,~,~)


for i = 1:self.n_channels
	if isempty(self.common.NNdata(i).label_idx)
		continue
	end

	if isempty(self.workers)
		% absolutely nothing, so let's train
		self.NNtrain(i);
	elseif length(self.workers) < i
		% no worker working on this channel, so let's train!
		if self.common.NNdata(i).isMoreTrainingNeeded
			self.NNtrain(i);
		end
	elseif strcmp(self.workers(i).State,'finished')
		% retrain!
		if self.common.NNdata(i).isMoreTrainingNeeded
			self.NNtrain(i);
		else
			self.handles.ax.NN_status(i).String = 'IDLE';
		end
	elseif strcmp(self.workers(i).State,'running')
		% update display
		self.handles.ax.NN_status(i).String = 'TRAINING';


		D = self.workers(i).Diary;


		if length(D) < 5
			continue
		end

		D = strsplit(D,'\n');


		ValidationAccuracy = [];
		for j = length(D):-1:1
			if strcmp(strtrim(D{j}),'ValidationAccuracy=')
				ValidationAccuracy = strtrim(D{j+1});
				break
			end
		end

		

		% read hash of data training on
		data_hash = '';
		for j = length(D):-1:1
			if strcmp(strtrim(D{j}),'hash of data training on =')
				data_hash = strtrim(D{j+1});
				break
			end
		end

		if ~isempty(ValidationAccuracy)
			self.handles.ax.NN_accuracy(i).String = oval(str2double(ValidationAccuracy),3);

			self.common.NNdata(i).accuracy_hash = data_hash;
			self.common.NNdata(i).accuracy = str2double(ValidationAccuracy);
		end


	end


end



