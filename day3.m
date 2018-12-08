function [num_overlap, pristine_claim] = day3(input_file)

fid = fopen(input_file);
data_cell = textscan(fid, '#%d @ %d,%d: %dx%d');
fclose(fid);

data = table(data_cell{:}, 'VariableNames', ...
    {'id', 'leftOffset', 'topOffset', 'width', 'height'});

% calculate max extents
max_x = max(data.leftOffset + data.width);
max_y = max(data.topOffset + data.height);

% allocate and fill claim count grid
num_claims = zeros(max_y, max_x);
last_claim = int32(zeros(max_y, max_x));
pristine = true(height(data), 1);

for kC = 1:height(data)
    row = data(kC, :);
    y_inds = row.topOffset + (1:row.height);
    x_inds = row.leftOffset + (1:row.width);
    
    num_claims(y_inds, x_inds) = num_claims(y_inds, x_inds) + 1;
    overlaps = setdiff(unique(last_claim(y_inds, x_inds)), 0);
    last_claim(y_inds, x_inds) = row.id;
    
    % mark all overlapped claims as not pristine, as well as this one
    % if there are any overlaps.
    if ~isempty(overlaps)
        pristine(row.id) = false;
        pristine(overlaps) = false;
    end
end

% part 1
num_overlap = sum(sum(num_claims > 1));

% part 2
pristine_claim = find(pristine);

end