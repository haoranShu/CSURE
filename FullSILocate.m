function [output_matrix,length,width,output_position,output_coor] = FullSILocate(input_image,input_template)
size_image = size(input_image);
size_template = size(input_template);
%locate the first one
temp_coor = SILocate(input_image,input_template);

%change template size according to the first result
size_template(1) = temp_coor(3,1) - temp_coor(1,1)+1;
size_template(2) = temp_coor(2,2) - temp_coor(1,2)+1;
input_template = imresize(input_template,size_template);

no_col = floor(size_image(2)/size_template(2));
no_row = floor(size_image(1)/size_template(1));
output_coor = zeros(4,2,no_col*no_row);

function output_position = position(coor,image_size,template_size)
    output_position = floor((coor(1,2)-1)/template_size(2))+1 + floor((coor(1,1)-1)/template_size(1))*floor(image_size(2)/template_size(2));
end

first_position = position(temp_coor,size_image,size_template);
output_coor(:,:,first_position) = temp_coor;

%input the scale-modified template and the original image
function output_direction_coor = direction_coor(temp_coor,input_image,input_template,direction,fluct)
    size_image = size(input_image);
    size_template = size(input_template);
    input_template_std = std2(input_template);
    input_template_avg = mean2(input_template);
    switch direction
        case 'left'
            row_min = max(1,temp_coor(1,1)-fluct);
            row_max = min(size_image(1),temp_coor(3,1)+fluct);
            col_min = max(1,temp_coor(1,2)-size_template(2)-fluct);
            col_max = min(size_image(2),temp_coor(2,2)-size_template(2)+fluct);
            temp_subimage = input_image(row_min:row_max,col_min:col_max);
        case 'right'
            row_min = max(1,temp_coor(1,1)-fluct);
            row_max = min(size_image(1),temp_coor(3,1)+fluct);
            col_min = max(1,temp_coor(1,2)+size_template(2)-fluct);
            col_max = min(size_image(2),temp_coor(2,2)+size_template(2)+fluct);
            temp_subimage = input_image(row_min:row_max,col_min:col_max);
        case 'up'
            col_min = max(1,temp_coor(1,2)-fluct);
            col_max = min(size_image(2),temp_coor(2,2)+fluct);
            row_min = max(1,temp_coor(1,1)-size_template(1)-fluct);
            row_max = min(size_image(1),temp_coor(3,1)-size_template(1)+fluct);
            temp_subimage = input_image(row_min:row_max,col_min:col_max);
        case 'down'
            col_min = max(1,temp_coor(1,2)-fluct);
            col_max = min(size_image(2),temp_coor(2,2)+fluct);
            row_min = max(1,temp_coor(1,1)+size_template(1)-fluct);
            row_max = min(size_image(1),temp_coor(3,1)+size_template(1)+fluct);
            temp_subimage = input_image(row_min:row_max,col_min:col_max);
    end
            coor_add = [row_min-1,col_min-1;row_min-1,col_min-1;row_min-1,col_min-1;row_min-1,col_min-1];
            output_direction_coor = coor_add + new_locate_level1(temp_subimage,input_template,input_template_std,input_template_avg);
end
%debug 
%output_coor = direction_coor(temp_coor,input_image,input_template,'down',10);
fluct = 10;
col_coor = temp_coor;
for col = 1: floor((temp_coor(1,2)-1)/size_template(2))
    col_coor = direction_coor(col_coor,input_image,input_template,'left',fluct);
    output_coor(:,:,position(col_coor,size_image,size_template)) = col_coor;
end

col_coor = temp_coor;
for col = 1: floor((size_image(2)-temp_coor(2,2))/size_template(2))
    col_coor = direction_coor(col_coor,input_image,input_template,'right',fluct);
    output_coor(:,:,position(col_coor,size_image,size_template)) = col_coor;
end

row_matrix = [];
for i = 1:no_col*no_row
    if output_coor(:,:,i) ~= [0,0;0,0;0,0;0,0] 
    row_matrix = cat(3,row_matrix, output_coor(:,:,i));
    end
end

for row_count = 1:size(row_matrix,3)
    row_coor = row_matrix(:,:,row_count);
    for row = 1:floor((row_matrix(1,1,row_count)-1)/size_template(1))
        row_coor = direction_coor(row_coor,input_image,input_template,'up',fluct);
        output_coor(:,:,position(row_coor,size_image,size_template)) = row_coor;
    end
    
    row_coor = row_matrix(:,:,row_count);
    for row = 1:floor((size_image(1)-row_matrix(3,1,row_count))/size_template(1))
        row_coor = direction_coor(row_coor,input_image,input_template,'down',fluct);
        output_coor(:,:,position(row_coor,size_image,size_template)) = row_coor;
    end
end

output_matrix = [];
for i = 1:no_col*no_row
    if output_coor(:,:,i) ~= [0,0;0,0;0,0;0,0] 
    output_matrix = cat(1,output_matrix, input_image(output_coor(1,1,i):output_coor(3,1,i),output_coor(1,2,i):output_coor(2,2,i)));
    end
end

length = output_coor(3,1,1) - output_coor(1,1,1) + 1;
width = output_coor(2,2,1) - output_coor(1,2,1) + 1;

output_position = [];
for i = 1:no_col*no_row
    if output_coor(:,:,i) ~= [0,0;0,0;0,0;0,0] 
    output_position = cat(1,output_position,[output_coor(1,1,i),output_coor(1,2,i)]);
    end
end

end