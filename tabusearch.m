%{
clear;
%define tour tr from .kp file

%****2 parameters: no_improvement, tabusize***********

file = fopen('dataset3.txt','r');
%capacity = fscanf(file, '%f', [1 2]);
tr = fscanf(file, '%f', [2 Inf]);
fclose(file);
capacity = 997;
tr = tr(1:2, :)';
items_weight = tr(:,2);
items_cost = tr(:,1);

wghtbyprft = items_weight./items_cost;   %weight to profit ratio
[~, indices] = sort(wghtbyprft);
index = max(indices);

x = randi(2,1,length(items_weight)) - randi(1,1,length(items_weight)); %random binary vector initialization
sack_obj = sack(x, capacity, items_weight, items_cost, indices);

%sack_obj = sack_obj.cal_weight();

while(sack_obj.weight>capacity)
    if sack_obj.selection_list(indices(index))
        sack_obj.selection_list(indices(index)) = 0; %items are neglected as per their detrimental ratio of weight to profit
    end
    sack_obj = sack_obj.cal_weight();
    %fprintf('\n%d',sack_obj.weight);
    index = index-1;
end

sack_obj = sack_obj.cal_cost();

tabusize = 100;
nimprv = 50;
niter = 5;

%}

function sBest = tabusearch(sack_obj, tabusize, nimprv, niter)

init_obj = sack_obj;
tabulist = sack_obj;
sBest = sack_obj;
no_improvement = 0;
last_cost = 0;
k =1; %VNS parameter

for iter=1: niter
while(no_improvement< nimprv)
    [neighbr, bitinfo] = getneighbourhood(sack_obj.selection_list, k); %k: parameter for VNS
    c = 1;
    sz = size(neighbr);
    
    for i=1:sz(1);
        sack_neighbr = sack(neighbr(i,:), sack_obj.capacity, sack_obj.items_weight, sack_obj.items_cost, sack_obj.indices);
        %sack_neighbr = sack_neighbr.recal_cost(sack_obj, items_cost(bitinfo(i)), neighbr(i, bitinfo(i))==0);
        %sack_neighbr = sack_neighbr.recal_weight(sack_obj, items_weight(bitinfo(i)), neighbr(i, bitinfo(i))==0);
        sack_neighbr = modify_sack(sack_neighbr, 'weight-to-profit');
        
        if ~ismember(sack_neighbr.selection_list, vertcat(tabulist(:).selection_list), 'rows')
            neighbours(c) = sack_neighbr ;
            c = c+1;
        end
    end
    for i=1:length(neighbours)
        cost(i) = neighbours(i).cost;
    end
    [bestcost, index3] = max(cost); %%
    bestcandidate = neighbours(index3);
    if (last_cost < bestcandidate.cost);
            no_improvement = 0;
            %fprintf('\nvrebvorvwrhvwhviw%d',c);
    else no_improvement = no_improvement+1;
            %fprintf('\nhello%d',c);
    end
    last_cost = bestcandidate.cost;
    tabulist = [tabulist; bestcandidate];
    sack_obj = bestcandidate;
    sz = size(tabulist);
    if sz(1)>tabusize  %..........parameter of tabu_search
        tabulist = tabulist(2:end);
    end
    if bestcost>sBest.cost
        sBest = bestcandidate;
    end
    fprintf('\n bestcost = %d \n', sBest.cost);
    fprintf('\n noiprvmnt = %d \n', no_improvement);
end
k=k+1;
no_improvement = 0;
sack_obj = init_obj;
end
end