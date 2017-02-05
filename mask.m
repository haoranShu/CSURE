function masked = mask(mat)
    sizeMat = size(mat);
    cutLength = round(sizeMat(2)/4);
    masked = [mat(:,(cutLength+1):(cutLength*2)),mat(:,cutLength*3+1:end)];
end