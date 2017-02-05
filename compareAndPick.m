function bestMatch = compareAndPick(dictionary, item)
    unitLength = size(item,1);
    totalLength = size(dictionary,1);
    
    if mod(totalLength, unitLength) ~= 0
        return
    end
    
    bestMatch = 0;
    cc = 0;
    
    k = totalLength/unitLength;
    for i = 1:k
        %cc_new = crosco(mask(item),mask(dictionary(((i-1)*unitLength+1):i*unitLength,:,:)));
        cc_new = crosco(item,dictionary(((i-1)*unitLength+1):i*unitLength,:,:));
        if cc_new > cc
            bestMatch = i;
            cc = cc_new;
        end
    end
end