%                 _                    _   
%   ___ _ __ __ _| |__  ___  ___  _ __| |_ 
%  / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
% | (__| | | (_| | |_) \__ \ (_) | |  | |_ 
%  \___|_|  \__,_|_.__/|___/\___/|_|   \__|
%
% gets snippets from the raw data
% usage:
% 
% V_snippets = getSnippets(self,channel, spiketimes)
% where channel is a integer
% and spiketimes is vector of vector indices

function V_snippets = getSnippets(self,channel, spiketimes)



if nargin == 2

	assert(mathlib.iswhole(channel),'channel should be a whole number')
	assert(channel>0,'Channel must be +ve integer')
	assert(channel <= self.n_channels,'Channel must be <= self.n_channels')

	spiketimes = self.putative_spikes(:,channel);
	spiketimes = find(spiketimes);

end

if isempty(spiketimes)
	return
end


before = ceil(self.sdp.t_before/(self.dt*1e3));
after = ceil(self.sdp.t_after/(self.dt*1e3));

V_snippets = zeros(before+after,length(spiketimes));


V = self.raw_data(:,channel);

for i = 1:length(spiketimes)

	if spiketimes(i) < before+1
		continue
	end

	if spiketimes(i) + after+1 > length(V)
		continue
	end

	raw_snippet = V(spiketimes(i)-before+1:spiketimes(i)+after);
	if self.isIntracellular(channel)
		V_snippets(:,i) = raw_snippet - mean(raw_snippet);
	else
    	V_snippets(:,i) = raw_snippet;
    end
end




