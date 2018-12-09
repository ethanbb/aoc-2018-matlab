function [best_guard_1, best_minute_1, best_guard_2, best_minute_2] = day4(input_file)

fid = fopen(input_file);
data_cell = textscan(fid, '[%{yyyy-MM-dd HH:mm}D %s', 'Whitespace', '', ...
    'Delimiter', {'] ', '\r\n'}, 'TextType', 'string');
fclose(fid);

data = table(data_cell{:}, 'VariableNames', {'time', 'info'});
data = sortrows(data); % chronological order
data.minute = minute(data.time);

% assemble data about how often each guard was asleep during each minute
guard_stats = table('Size', [0, 2], 'VariableTypes', {'int32', 'int32'}, ...
    'VariableNames', {'id', 'asleepFreq'});

curr_guard = [];
sleep_start = [];
for kR = 1:height(data)
    guard_num = sscanf(data{kR, 'info'}, 'Guard #%d begins shift');
    if ~isempty(guard_num)
        curr_guard = guard_num;
        continue;
    end
    
    if strcmp(data{kR, 'info'}, 'falls asleep')
        sleep_start = data{kR, 'minute'};
        continue;
    end
    
    assert(strcmp(data{kR, 'info'}, 'wakes up'), 'huh?');
    sleep_end = data{kR, 'minute'} - 1;
    
    row = find(guard_stats.id == curr_guard, 1);
    if isempty(row)
        guard_stats = [guard_stats; {curr_guard, zeros(1, 60)}];
        row = height(guard_stats);
    end
    
    guard_stats{row, 'asleepFreq'}((sleep_start:sleep_end) + 1) = ...
        guard_stats{row, 'asleepFreq'}((sleep_start:sleep_end) + 1) + 1;
end

% part 1
guard_stats.asleepTotal = sum(guard_stats.asleepFreq, 2);
[~, sleepiest_ind] = max(guard_stats.asleepTotal);
best_guard_1 = guard_stats.id(sleepiest_ind);
[~, best_minute_ind] = max(guard_stats{sleepiest_ind, 'asleepFreq'});
best_minute_1 = best_minute_ind - 1;

% part 2
[~, best_combo_ind] = max(guard_stats.asleepFreq(:));
[best_guard_ind, best_minute_ind] = ind2sub(size(guard_stats.asleepFreq), best_combo_ind);
best_guard_2 = guard_stats.id(best_guard_ind);
best_minute_2 = best_minute_ind - 1;

end