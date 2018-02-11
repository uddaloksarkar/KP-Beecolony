function [neighbours, bitflipinfo] = getneighbourhood(binarr, k)
%%neighbourhood generator function of binary array
%bitflipinfo carries the information about which bit is flipped
%corresponding to a neighbour

neighbours = [];
bitflipinfo = [];


for i =1:floor(length(binarr)/k)
    %if ((binarr(i)~= 1)&&(binarr(i)~= 0))
    %    error('input array must be logical');
    %end
    new = arrflip(binarr, k*(i-1)+1, k*i);
    neighbours = [neighbours; new];
    %bitflipinfo = [bitflipinfo; i];
end
end

function arr = arrflip(arr, a, b)
    for i=a:b
        if arr(i)==0
            arr(i)=1;
        else arr(i)=0;
        end
    end
end
