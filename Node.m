classdef Node < handle
    % Node for a doubly-linked list w/ sentinel. Holds data, a forward
    % pointer and a backward pointer.
    
    properties
        data = []
        prev Node
        next Node
    end
    
    methods        
        function obj = Node(dataIn)
            if nargin > 0
                obj.data = dataIn;
            end
            obj.prev = obj;
            obj.next = obj;
        end
    end
end

