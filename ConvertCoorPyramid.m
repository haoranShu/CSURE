function output = ConvertCoorPyramid(input_coor,direction,level_size)
%to reduce or expand the coordinate between levels of pyramid
%the default level size is 2
%input is a 4*2 matrix indicates the 4 pts of the rectangle
% p1(row,col) ---- p2(row,col)
%     |                 |
%     |                 |
% p3(row,col) ---- p4(row,col)
%so is output
if exist('level_size') == false
    level_size = 2;
end

output = zeros(4,2);
switch direction
    case 'expand'
        output = floor(level_size*(input_coor-[1,1;1,1;1,1;1,1])+[1,1;1,1;1,1;1,1]);
    case 'reduce'
        output = floor((1/level_size)*(input_coor-[1,1;1,1;1,1;1,1])+[1,1;1,1;1,1;1,1]);
end

end