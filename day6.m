function [largest_area, near_area] = day6(input_file)

pts = csvread(input_file);

% transform so both dimensions have min of 1
pts = pts - min(pts) + 1;
grid_size = [max(pts(:, 1)), max(pts(:, 2))];
pts_ind = sub2ind(grid_size, pts(:, 1), pts(:, 2));

numpts = size(pts, 1);

% part 1

% vector of claimed areas
areas = ones(numpts, 1);

% grid of claiming coordinates
claims = zeros(grid_size);
claims(pts_ind) = 1:numpts;

% grid of shortest distances to coordinate
shortest_dists = inf(grid_size);
shortest_dists(pts_ind) = 0;

% loop through, expanding claimed areas until all are either infinite
% or not changing.
curr_dist = 0;
while any(~isfinite(shortest_dists(:)))
    curr_dist = curr_dist + 1;
    for kP = 1:numpts
        expand_claim(kP, curr_dist);
    end
end

% disqualify origin coordinates with claims on the edges, since these
% will be infinite
inf_claims = unique([claims(1, :), claims(end, :), claims(:, 1)', claims(:, end)']);
finite_claims = setdiff(1:numpts, inf_claims);
largest_area = max(areas(finite_claims));


% part 2

total_dist_thresh = 10000;
% prepare for 2d convolution
% beyond the bounding box of points in each direction, distance at each
% step moving away increases by the number of points. so by ceil(10000/#points)
% steps, distance should be >= 10000.
pad_size = ceil(total_dist_thresh / numpts);
pts = pts + pad_size;
padded_grid_size = grid_size + 2*pad_size;
padded_pts_ind = sub2ind(padded_grid_size, pts(:, 1), pts(:, 2));
pt_locs = false(padded_grid_size);
pt_locs(padded_pts_ind) = true;

kernel_x = [(padded_grid_size(1)-1:-1:0)'; (1:padded_grid_size(1)-1)'];
kernel_y = [(padded_grid_size(2)-1:-1:0) , (1:padded_grid_size(2)-1) ];
kernel = kernel_x + kernel_y;

total_dist = conv2(pt_locs, kernel, 'same');
near_area = sum(sum(total_dist < total_dist_thresh));


%----------------- local fcns ------------------%

    function expand_claim(kP, distance)
        center = pts(kP, :);
        for dX = -distance:distance
            for dY = unique([distance-abs(dX), -(distance-abs(dX))])
                point = center + [dX, dY];
                
                if any(point > grid_size | point < 1)
                    % skip points outside the grid
                    continue;
                end
                
                point_ind = sub2ind(grid_size, point(1), point(2));
                if shortest_dists(point_ind) < distance
                    % already claimed, skip
                    continue;
                elseif shortest_dists(point_ind) == distance
                    % tied with another coordinate(s)
                    % decrement that one's count and reset the claim
                    curr_claim = claims(point_ind);
                    if curr_claim > 0
                        areas(curr_claim) = areas(curr_claim) - 1;
                        claims(point_ind) = 0;
                    end
                else
                    % unclaimed - claim this point.
                    areas(kP) = areas(kP) + 1;
                    claims(point_ind) = kP;
                    shortest_dists(point_ind) = distance;
                end
            end
        end
    end

end