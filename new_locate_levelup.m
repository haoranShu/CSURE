function [output_coor,cc] = new_locate_levelup(input_image,input_template,iteration,input_template_std,input_template_avg)
%output format is as follows
% p1(row,col) ---- p2(row,col)
%     |                 |
%     |                 |
% p3(row,col) ---- p4(row,col)
output_coor = zeros(4,2);
fluct = 5;
imsize = size(input_image);
py_image = impyramid(input_image,'reduce');
py_template = impyramid(input_template,'reduce');

if iteration == 1
    output_coor = new_locate_level1(py_image,py_template,input_template_std,input_template_avg);
else
    output_coor = new_locate_levelup(py_image,py_template,iteration-1,input_template_std,input_template_avg);
end
%imshow(py_image);pause
%imshow(py_template);pause
output_coor = ConvertCoorPyramid(output_coor,'expand',2);
%imshow(input_image(max(output_coor(1,1)-fluct,1):min(output_coor(3,1)+fluct,imsize(1)),max(output_coor(1,2)-fluct,1):min(output_coor(2,2)+fluct,imsize(2))));pause
coor_add = [max(output_coor(1,1)-fluct,1),max(output_coor(1,2)-fluct,1);max(output_coor(1,1)-fluct,1),max(output_coor(1,2)-fluct,1);max(output_coor(1,1)-fluct,1),max(output_coor(1,2)-fluct,1);max(output_coor(1,1)-fluct,1),max(output_coor(1,2)-fluct,1);];
[output_coor,cc] =  new_locate_level1(input_image(max(output_coor(1,1)-fluct,1):min(output_coor(3,1)+fluct,imsize(1)),max(output_coor(1,2)-fluct,1):min(output_coor(2,2)+fluct,imsize(2))),input_template,input_template_std,input_template_avg);
output_coor = coor_add + output_coor;
end
