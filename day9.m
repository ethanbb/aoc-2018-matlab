function [high_score, high_score_x100] = day9(input_file)

fid = fopen(input_file);
num_elves = fscanf(fid, '%d players; ');
last_marble = fscanf(fid, 'last marble is worth %d points');
fclose(fid);

% handle class manipulation is really slow! :(
% this takes about an hour or two (I didn't measure exactly); the below
% solution takes 0.28 seconds (for the original number of marbles)
% 
% circle = DLLSentinel;
% add(circle, 0);
% 
% scores = zeros(num_elves, 1);
% elf = 1;
%
% for kM = 1:last_marble
%     if mod(kM, 23) ~= 0
%         move(circle, 1);
%         add(circle, kM);
%     else
%         scores(elf) = scores(elf) + kM;
%         move(circle, -7);
%         scores(elf) = scores(elf) + remove(circle);
%     end
%     
%     elf = mod(elf, num_elves) + 1;
% end
%
% high_score = max(scores);

high_score = calc_score(num_elves, last_marble);
high_score_x100 = calc_score(num_elves, last_marble * 100);

end

% array-of-structs solution
function high_score = calc_score(num_elves, last_marble)

circle = struct('number', nan, 'next', nan, 'prev', nan);
circle = repmat(circle, last_marble + 1, 1);

circle(1).number = 0;
circle(1).next = 1; % refers to index in array
circle(1).prev = 1;
current = 1;

scores = uint32(zeros(num_elves, 1));
elf = 1;

for kM = 1:last_marble
    if mod(kM, 23) ~= 0
        current = circle(current).next;
        [circle, current] = add_marble(circle, current, kM);
    else
        scores(elf) = scores(elf) + kM;
        for kS = 1:7
            current = circle(current).prev;
        end
        [number, circle, current] = remove_marble(circle, current);
        scores(elf) = scores(elf) + number;
    end
    
    elf = mod(elf, num_elves) + 1;
end

high_score = max(scores);

end

function [circle, current] = add_marble(circle, current, kM)
other = circle(current).next;
circle(kM+1).number = kM;
circle(kM+1).prev = current;
circle(kM+1).next = other;
circle(current).next = kM+1;
circle(other).prev = kM+1;
current = kM+1;
end

function [number, circle, current] = remove_marble(circle, current)
number = circle(current).number;
prev = circle(current).prev;
next = circle(current).next;
circle(prev).next = next;
circle(next).prev = prev;
current = next;
end

