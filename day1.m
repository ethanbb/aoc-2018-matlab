function [freq_end, rep_freq] = day1(input_file)

t = readtable(input_file, 'ReadVariableNames', false);
changes = t{:, 1};

% part 1
freq_end = sum(changes);

% part 2 (ugly :( )
start_inds = 0:length(changes)-1;
first_repeats = arrayfun(@first_repeat, start_inds);
[~, min_rep_ind_k] = min(first_repeats);
start_ind = start_inds(min_rep_ind_k);
rep_freq = sum(changes(1:start_ind));

    function min_rep_ind = first_repeat(ind)
        
        start_val = sum(changes(1:ind));
        cycle_change = sum(changes);
        num_changes = length(changes);
        
        cum_freq = cumsum(changes);
        cum_freq_unwrapped = [cum_freq(ind+1:end); cum_freq(1:ind) + cycle_change];
        first_diff = cum_freq_unwrapped - start_val;
        cycles_to_repeat = -first_diff / cycle_change;
        cycles_to_repeat(cycles_to_repeat < 0) = inf;
        cycles_to_repeat(mod(cycles_to_repeat, 1) ~= 0) = inf;
        
        rep_ind = ind + (1:num_changes)' + cycles_to_repeat * num_changes;
        min_rep_ind = min(rep_ind);
        
    end

end