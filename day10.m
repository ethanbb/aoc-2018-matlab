function [message, secs] = day10(input_file)

fid = fopen(input_file);
data_cell = textscan(fid, 'position=<%d, %d> velocity=<%d, %d>');
fclose(fid);

pos = [data_cell{1}, data_cell{2}];
vel = [data_cell{3}, data_cell{4}];

message = '';
secs = 0;
multiple = 200;
figure;
while isempty(message)
    % move the points
    pos = pos + multiple * vel;
    secs = secs + multiple;
    
    scatter(pos(:, 1), -pos(:, 2));
    message = input('Enter the message if you see one: ', 's');
    
    if isempty(message)
        new_m = input(sprintf('Move by how many steps? (%d): ', multiple));
        if ~isempty(new_m)
            multiple = new_m;
        end
    end
end

end
