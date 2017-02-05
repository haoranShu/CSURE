function [grouping] = kmeans(images, k, nIter, sizeSet)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sizeInput = size(images);

%randome initialization

sizePoint = sizeInput;
sizePoint(1) = sizePoint(1)/sizeSet;

centers = [];
for i = 1:k
    centers = [centers;rand(sizePoint)*255];
end

grouping = [];
for i = 1:nIter
    %calculate grouping
    for j = 1:sizeSet
        dist = 1;
        for n = 1:k
            if ((1-crosco(centers(n),images((j-1)*sizePoint(1):j*sizePoint(1),:,:))) < dist)
                dist = 1-crosco(centers(n),images((j-1)*sizePoint(1):j*sizePoint(1),:,:))));
                group = k;
            end
        end
        grouping = [grouping, group];
    end
    
    %reallocate centers
    for n = 1:k
        totalMat = zeros(sizePoint);
        numPoints = 0;
        for j = 1:sizeSet
            if (grouping(j) == n)
                totalMat = totalMat + images((j-1)*sizePoint(1):j*sizePoint(1),:,:)));
                numPoints = numPoints + 1;
            end
        end
        centers(n) = totalMat./numPoints;
    end
    grouping = [];
end

for j = 1:sizeSet
    dist = 1;
    for n = 1:k
        if ((1-crosco(centers(n),images((j-1)*sizePoint(1):j*sizePoint(1),:,:))))) < dist)
            dist = 1-crosco(centers(n),images((j-1)*sizePoint(1):j*sizePoint(1),:,:))));             
            group = k;
        end
    end
    grouping = [grouping, group];
end

end

