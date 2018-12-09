function [new_len, min_improved_len] = day5(input_file)

fid = fopen(input_file);
data_cell = textscan(fid, '%s');
fclose(fid);
polymer = data_cell{1}{1};

% part 1
new_len = react(polymer);

% part 2
unit_types = unique(lower(polymer));
min_improved_len = new_len;
for kU = 1:length(unit_types)
    improved_polymer = polymer;
    improved_polymer(improved_polymer == unit_types(kU)) = [];
    improved_polymer(improved_polymer == upper(unit_types(kU))) = [];
    improved_len = react(improved_polymer);
    min_improved_len = min(min_improved_len, improved_len);
end

end

function new_len = react(polymer)

% delete pairs starting on even and odd indices separately, to avoid
% overlaps. not super elegant but it should work.

old_len = inf;
new_len = length(polymer);
while new_len < old_len
    old_len = new_len;
    for oddeven = 0:1
        pairs = abs(diff(polymer)) == 32 & mod(1:length(polymer) - 1, 2) == oddeven;
        pair_deletions = [pairs, false] | [false, pairs];
        polymer(pair_deletions) = [];
    end
    new_len = length(polymer);
end

end