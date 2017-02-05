function output = crosco( image1, image2 )
    %image1 = imread(im1);
    %image2 = imread(im2);
    %image1 = im2double(image1);
    %image2 = im2double(image2);
    imsize = size(image1);
    %assuming that image1 and image2 have the same size
    
    if length(imsize) > 3
        return
    end
    
    %calculate sd of image1 and image2
    %did not divide by n for error minimizing (n will be cancelled)
    avg1 = sum(sum(sum(image1)))/numel(image1);
    avg2 = sum(sum(sum(image2)))/numel(image2);
    sd1 = sqrt(sum(sum(sum((image1-avg1).^2)))); 
    sd2 = sqrt(sum(sum(sum((image2-avg2).^2))));
    
    %calculating crosco
    output = sum(sum(sum((image1-avg1).*(image2-avg2))))/(sd1*sd2);
end