function [output_coor,cc] = new_locate_level1(input_image,input_template,input_template_std,input_template_avg);
%output format is as follows
% p1(row,col) ---- p2(row,col)
%     |                 |
%     |                 |
% p3(row,col) ---- p4(row,col)
imsize = size(input_image);
templatesize = size(input_template);
output_coor = zeros(4,2);
cc = 0;
%counter = 0;
for row = 1:imsize(1)-templatesize(1)+1
    for col = 1:imsize(2)-templatesize(2)+1
        
        cc_new = crosco_more_input(input_template,input_image(row:row+templatesize(1)-1,col:col+templatesize(2)-1),input_template_std,input_template_avg);
        if cc_new > cc
            cc = cc_new;
            output_coor = [row,col;row,col+templatesize(2)-1;row+templatesize(1)-1,col;row+templatesize(1)-1,col+templatesize(2)-1];
        end
        %counter = counter+1;
    end
end
%counter;

end
        