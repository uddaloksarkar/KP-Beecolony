function sack_obj = modify_sack(sack_obj, string)

if strcmp(string, 'weight-to-profit')
    index = max(sack_obj.indices);
    while(sack_obj.weight>sack_obj.capacity)
        if sack_obj.selection_list(sack_obj.indices(index))
            sack_obj.selection_list(sack_obj.indices(index)) = 0; %items are neglected as per their detrimental ratio of weight to profit
        end
        sack_obj = sack_obj.cal_weight();
        %fprintf('\n%d',sack_obj.weight);
        index = index-1;
    end
    sack_obj = sack_obj.cal_cost();
end

if strcmp(string, 'random')
    while(sack_obj.weight>sack_obj.capacity)
        index = randi(length(sack_obj.selection_list));
        if sack_obj.selection_list(index)
            sack_obj.selection_list(index) = 0; %items are neglected as per their detrimental ratio of weight to profit
        end
        sack_obj = sack_obj.cal_weight();
        %fprintf('\n%d',sack_obj.weight)
    end
    sack_obj = sack_obj.cal_cost();
end

end