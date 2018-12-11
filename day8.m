function [meta_sum, val] = day8(input_file)

% part 1
fid = fopen(input_file);
meta_sum = metadata_sum(fid);
fclose(fid);

% part 2
fid = fopen(input_file);
val = value(fid);
fclose(fid);

end

function meta_sum = metadata_sum(fid)

nchild = fscanf(fid, '%d', 1);
nmeta  = fscanf(fid, '%d', 1);

meta_sum = 0;
for kC = 1:nchild
    meta_sum = meta_sum + metadata_sum(fid);
end

metadata = fscanf(fid, '%d', nmeta);
meta_sum = meta_sum + sum(metadata);

end

function val = value(fid)

nchild = fscanf(fid, '%d', 1);
nmeta  = fscanf(fid, '%d', 1);

child_values = zeros(nchild, 1);
for kC = 1:nchild
    child_values(kC) = value(fid);
end

metadata = fscanf(fid, '%d', nmeta);
if nchild == 0
    val = sum(metadata);
else
    valid_children = metadata(metadata > 0 & metadata <= nchild);
    val = sum(child_values(valid_children));
end

end