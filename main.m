clear;
%define tour tr from .tsp file

file = fopen('dataset3.txt','r');
%capacity = fscanf(file, '%f', [1 2]);
tr = fscanf(file, '%f', [2 Inf]);
fclose(file);
capacity = 997;
tr = tr(1:2, :)';
items_weight = tr(:,2);
items_cost = tr(:,1);
tabusize = 100;
nimprv = 50;

wghtbyprft = items_weight./items_cost;   %weight to profit ratio
[~, indices] = sort(wghtbyprft);

index = max(indices);
x = randi(2,1,length(items_weight)) - randi(1,1,length(items_weight)); %random binary vector initialization
sack_obj = sack(x, capacity, items_weight, items_cost, indices);

%sack_obj = sack_obj.cal_weight(items_weight);
sack_obj = modify_sack(sack_obj, 'weight-to-profit');
%{
while(sack_obj.weight>capacity)
    if sack_obj.selection_list(indices(index))
        sack_obj.selection_list(indices(index)) = 0; %items are neglected as per their detrimental ratio of weight to profit
    end
    sack_obj = sack_obj.cal_weight();
    %fprintf('\n%d',sack_obj.weight);
    index = index-1;
end
sack_obj = sack_obj.cal_cost();
%}

%=======%

%=======%
colonysize = 10;
sacks = beecolony(sack_obj, colonysize);

start_time = tic();
iterations = 4;
count = 1;
for iter = 1:iterations
    fprintf('\nArtificial Bee Colony :: iteration number: %d', count);
    sacks = sacks.sendemployed();
    now = tic();
    sacks = sacks.updt_employed('tabusearch');
    updt_time = toc(now);
    fprintf('\nEmployed Bees Update Time = %d', updt_time);
    sacks = sacks.sendonlookers();
    fprintf('\nOnlookers : %d', length(sacks.onlookers));
    fprintf('\nScouts : %d', length(sacks.scout));
    sacks = sacks.sendscouts();
    sacks = sacks.waggledance();
    count = count+1;
end

bestcost = 0;
for i=1:length(sacks.onlookers)
    cost = sacks.onlookers(i).cost;
    if cost>bestcost
        besttour = sacks.onlookers(i);
        bestcost = cost;
    end
end

runtime = toc(start_time);
fprintf('\ntotal runtime = %d\n', runtime);
