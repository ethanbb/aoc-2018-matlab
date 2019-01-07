function [part1, part2] = day11(serial_num)

gridsize = 300;
[x, y] = meshgrid(1:gridsize, 1:gridsize);
rack_id = x + 10;

% do the algorithm
power = rack_id .* y;
power = power + serial_num;
power = power .* rack_id;
power = floor(power ./ 100);
power = mod(power, 10);
power = power - 5;

max_power = zeros(gridsize, 1);
max_x = zeros(gridsize, 1);
max_y = zeros(gridsize, 1);
total_power = cell(gridsize, 1);
total_power{1} = power;

for kS = 1:gridsize
    % calculate total power of kS x kS grids,
    % using past calculations if possible    
    prime_factors = factor(kS);
    largest_factor = prod(prime_factors(2:end));
    total_power{kS} = sum_squares(total_power{largest_factor}, kS, largest_factor);
    
    % find best square
    [max_power(kS), max_ind] = max(total_power{kS}(:));
    [max_y(kS), max_x(kS)] = ind2sub(size(total_power{kS}), max_ind);
end

part1 = [max_x(3), max_y(3)];

[~, best_size] = max(max_power);
part2 = [max_x(best_size), max_y(best_size), best_size];

end

% sum all possible size x size squares in input,
% taking only every "strideth" element.
function sums = sum_squares(input, size, stride)

kernel1d = zeros(size - (stride - 1), 1);
kernel1d(1:stride:end) = 1;
kernel = kernel1d .* kernel1d';

sums = xcorr2(input, kernel);

% trim
extra = length(kernel1d) - 1;
sums = sums(1+extra:end-extra, 1+extra:end-extra);

end