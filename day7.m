function [order, elapsed] = day7(input_file)

fid = fopen(input_file);
data_cell = textscan(fid, 'Step %s must be finished before step %s can begin.');
fclose(fid);

% make directed graph
g = digraph(data_cell{1}, data_cell{2});

% part 1

% sort nodes alphabetically
g = reordernodes(g, sort(g.Nodes.Name));

% topological sort
ind_order = toposort(g, 'Order', 'stable');
order = cell2mat(g.Nodes.Name(ind_order)');

% part 2
elapsed = 0;
curr_step = repmat({'.'}, 5, 1);
seconds_left = zeros(5, 1);

while numnodes(g) > 0
    % assign work
    free_elves = find(seconds_left == 0);
    ready_steps = setdiff(g.Nodes.Name(indegree(g) == 0), curr_step);
    num_to_assign = min(length(free_elves), length(ready_steps));
    for kA = 1:num_to_assign
        step = ready_steps{kA};
        curr_step{free_elves(kA)} = step;
        seconds_left(free_elves(kA)) = step - 'A' + 61;
    end
    
    % do work
    assigned_elves = seconds_left > 0;
    seconds_left(assigned_elves) = seconds_left(assigned_elves) - 1;
    elapsed = elapsed + 1;
    
    % delete completed steps
    done_elves = seconds_left == 0 & ~strcmp(curr_step, '.');
    g = rmnode(g, curr_step(done_elves));
    curr_step(done_elves) = {'.'};
end

end