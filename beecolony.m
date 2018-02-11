classdef beecolony
   
    properties
        colonysize;
        dimension;
        colony;
        employed;
        onlookers;
        scout;
    end
    
    methods
        function obj = beecolony(instance, colonysize)
            %to be changed for different implementations
            obj.colonysize = colonysize;
            sz = length(instance.selection_list);
            obj.dimension = sz;
            obj.colony = [];
            
            for m = 1:colonysize
                x = randi(2,1,sz) - randi(1,1,sz); %random binary vector initialization
                sack_obj = sack(x, instance.capacity, instance.items_weight, instance.items_cost, instance.indices);
                sack_obj = modify_sack(sack_obj, 'weight-to-profit');                
                obj.colony = [obj.colony sack_obj];
            end
        end
        
        function obj = sendemployed(obj)
            obj.employed = obj.colony;
        end
        
        function obj = sendonlookers(obj)
            cost = [];
            for i = 1:obj.colonysize
                cost(i) = obj.employed(i).cost;
            end
            probability = cost/sum(cost);%probability of *not* getting selected 
            probability = (probability - min(probability))/(max(probability) - min(probability)); %scaling onto [0,1]
            obj.onlookers = [];
            obj.scout = [];
            for i=1:obj.colonysize
                r = rand();    
                if r<probability(i)   %.... '<' for KP or '>' for TSP
                    %probability based determination of onlookers
                    obj.onlookers = [obj.onlookers obj.employed(i)];
                else obj.scout=[obj.scout obj.employed(i)]; %failed bees turned into scouts
                end
            end
        end
        
        function obj = sendscouts(obj)
            ln = length(obj.scout);
            sz = obj.dimension;
            instance = obj.scout(1);
            obj.scout = [];
            for i=1:ln
                x = randi(2,1,sz) - randi(1,1,sz); %random binary vector initialization
                sack_obj = sack(x, instance.capacity, instance.items_weight, instance.items_cost, instance.indices);
                sack_obj = modify_sack(sack_obj, 'weight-to-profit');                
                obj.scout = [obj.scout sack_obj];
                %obj.scout = [obj.scout tour(instance(randperm(obj.dimension),:))];
            end
        end
        
        function obj = waggledance(obj)
            obj.colony = [obj.onlookers obj.scout];
        end
        
        function obj = updt_employed(obj,string)
            for i =1:obj.colonysize
                obj.employed(i) = local_search(obj.employed(i),string);
            end
        end
        
    end
    
end

function solution = local_search(solution, search_algorithm, param1, param2, param3)
    if nargin>0
        if strcmp(search_algorithm, 'two_opt')
            if nargin<3
                param1 = 2; %default niteration
            end
            solution = two_opt(solution, param1);
        end
        if strcmp(search_algorithm, 'tabusearch')
            if nargin<3
                param1 = 100; %default tabusize
                param2 = 10; %default nimprove
                param3 = 5; %default iteration
            end
            solution = tabusearch(solution, param1, param2, param3);
        end
    else error('not enough input arguements');
    end
end