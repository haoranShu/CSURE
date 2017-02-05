%search for x, calculate percentile, search percentile, calculate
function image = levelAdjust(image1, image2)
    size1 = numel(image1);
    size2 = numel(image2);
    
    rank = 1;
    image2rank = zeros(size(image2));
    for j = 0:255
        for k = 1:size2
            if image2(k) == j
                image2rank(k) = rank;
                rank = rank+1;
            end
        end
    end
    
    done = 0;
    for i = 0:255
        sum1 = sum(image1(:)==i);
        ratio2 = round(sum1*size2/size1);
        done1 = done;
        done2 = done + ratio2;
        for k = 1:size2
            if (image2rank(k)>done1) && (image2rank(k)<=done2)
                image2(k) = i;
                done = done+1;
            end
        end
    end
                
    image = image2;
end