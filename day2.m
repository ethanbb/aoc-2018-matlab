function [checksum, common_chars] = day2(input_file)

fid = fopen(input_file);
ids = textscan(fid, '%s');
fclose(fid);
ids = ids{1};

% part 1
[has_double, has_triple] = cellfun(@check_id, ids);
num_with_double = sum(has_double);
num_with_triple = sum(has_triple);
checksum = num_with_double * num_with_triple;

% part 2
row = 1;
common_chars = [];
while isempty(common_chars) && row < length(ids)
    common_chars = find_common_with_first(ids(row:end));
    row = row + 1;
end

end

function [has_double, has_triple] = check_id(id)

counts = zeros(26, 1);
for kC = 1:length(id)
    bin = 1 + double(id(kC)) - double('a');
    counts(bin) = counts(bin) + 1;
end

has_double = any(counts == 2);
has_triple = any(counts == 3);

end

function common_chars = find_common_with_first(ids)
ids_num = double(cell2mat(ids));
diffs = ids_num - ids_num(1, :);
num_diff = sum(logical(diffs), 2);
diff_by_one = find(num_diff == 1);

if isempty(diff_by_one)
    common_chars = [];
else
    % found almost-matching ids!
    assert(numel(diff_by_one) == 1, 'huh?');
    common_chars = char(ids_num(1, ids_num(1, :) == ids_num(diff_by_one, :)));
end

end