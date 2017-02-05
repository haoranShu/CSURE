function hog = hogFeatures(cellSize, im)
    run('./vlfeat/toolbox/vl_setup');
    %im = imread(image);
    im = single(im);
    hog = vl_hog(im, cellSize);
    %imhog = vl_hog('render', hog, 'verbose');
    %clf; imagesc(imhog); colormap gray;
end