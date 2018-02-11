classdef sack
   
    properties
        capacity;
        weight;
        cost;
        selection_list;
        items_weight;
        items_cost;
        indices;    %sorted index of weight to profit ratio
    end
    
    methods
        function obj = sack(list, capacity, items_weight, items_cost, indices)
            obj.capacity = capacity;
            obj.selection_list = list;
            obj.items_weight = items_weight;
            obj.items_cost = items_cost;
            obj.indices = indices;
            obj = cal_weight(obj);
            obj = cal_cost(obj);
        end
        %{
        function obj = sack(list, capacity)
            if nargin==1
                obj.selection_list = list;
            end
            if nargin==2
                obj.selection_list = list;
                obj.capacity = capacity;
            end
        end
        %}
        function obj = cal_weight(obj)
            obj.weight = obj.selection_list * obj.items_weight;
        end
        
        function obj = cal_cost(obj)
            obj.cost = obj.selection_list * obj.items_cost;
        end
        
        function obj = recal_weight(obj, obj2, item_weight, cond)
            if cond
                obj.weight = obj2.weight - item_weight;
            else obj.weight = obj2.weight + item_weight;
            end
        end
        
        function obj = recal_cost(obj, obj2, item_cost, cond)
            if cond
                obj.cost = obj2.cost - item_cost;
            else obj.cost = obj2.cost + item_cost;
            end
        end
    end
end