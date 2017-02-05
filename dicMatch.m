function match = dicMatch(dictionary, microscopy, cellSize)
    %dictionary: N*1 cell of strings
    %microscopy: an image
    numDic = size(dictionary, 1);
    dicSample = imread(char(dictionary(1)));
    dicSample2 = im2double(dicSample);
    microscopy = imread(microscopy);
    microscopy = im2double(microscopy);
    
    [items, itemLength, itemWidth, positions] = FullSILocate(microscopy, dicSample2);
    
    length = size(items,1);
    if mod(length, itemLength) ~= 0
        return
    end
    
    dic = []; dicFeatures = [];
    for j = 1: numDic
        dictmp = imread(char(dictionary(j)));
        dictmp = double(dictmp);
        dic = [dic; dictmp];
        dictmp = mask(dictmp);
        hogtmp = hogFeatures(cellSize, dictmp);
        dicFeatures = [dicFeatures;hogtmp];
    end
    
    %hogLength = size(dicFeatures,1)/size(hogtmp,1);
    
    match = [];
    numItem = length/itemLength;
    figure;
    hAx = axes;
    imshow(microscopy, 'Parent',hAx);
    hold on;
    for i = 1:numItem
        item = items(((i-1)*itemLength+1):i*itemLength,:);
        item = uint8(item*255);
        item = levelAdjust(dicSample,item);
        %item2 = [item2; item];
        item = imresize(item, size(dicSample));
        itemComp = mask(item);
        %itemComp = levelAdjust(mask(dicSample), itemComp);
        hogItem = hogFeatures(cellSize, itemComp);
        match = [match;compareAndPick(dicFeatures, hogItem)];
        imrect(hAx, [positions(i,2),positions(i,1),itemWidth, itemLength]);
        txt = num2str(match(i));
        text(positions(i,2)+round(itemWidth/5),positions(i,1)+round(itemLength/5),txt,'HorizontalAlignment', 'right');
    end
end