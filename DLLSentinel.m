classdef DLLSentinel < handle
    % Doubly-linked list with a sentinel.
    
    properties
        sentinel Node
        current Node
        size int32 = 0
    end
    
    methods
        function obj = DLLSentinel()
            obj.sentinel = Node;
            obj.current = obj.sentinel;
        end
        
        function move(obj, distance)
            % moves current pointer forward or backward through the list
            assert(mod(distance, 1) == 0, 'Distance must be an integer');
            
            if distance == 0 || obj.size < 2
                return;
            end
            
            if distance > 0
                prop = 'next';
            else
                prop = 'prev';
            end
            
            for kM = 1:abs(distance)
                obj.current = obj.current.(prop);
                if obj.current == obj.sentinel
                    obj.current = obj.current.(prop);
                end
            end
        end
        
        function add(obj, newData)
            % adds a node with newData after the current node, and then
            % makes the current node the newly inserted one.
            newNode = Node(newData);
            newNode.prev = obj.current;
            newNode.next = obj.current.next;
            obj.current.next.prev = newNode;
            obj.current.next = newNode;
            obj.current = newNode;
            obj.size = obj.size + 1;
        end
        
        function data = remove(obj)
            % removes the current element and returns its data. Attempting
            % to remove from an empty list is an error. The next node in
            % the list then becomes the current node.
            assert(obj.size > 0, 'Cannot remove from an empty list');
            data = obj.current.data;
            nextnode = obj.current.next;
            obj.current.prev.next = nextnode;
            nextnode.prev = obj.current.prev;
            obj.current = nextnode;
            obj.size = obj.size - 1;
            
            if obj.current == obj.sentinel && obj.size > 0
                obj.current = obj.current.next;
            end
        end
    end
end

