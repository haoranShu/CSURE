function [output,output_scale] = ScaleSearch(input_image,input_template,fluct);
%fluct defines the ranges
%e.g. [1 2]
%then the program searches from fluct(1),fluct(2),....fluct(end) to find
%the suitable one
size_image = size(input_image);
std_template = std2(input_template);
mean_template = mean2(input_template);
compare_template = imresize(input_template,fluct(1));
size_template = size(compare_template);
input_size = min(size_image,max(2*size_template,floor(size_image/2)));
iteration = min(floor(min(log(input_size)/log(2)-6)),floor(min(log(input_size)/log(2)-5)));
output_scale = fluct(1);
[best_fit_coor,best_fit_cc] = new_locate_levelup(input_image(1:input_size(1),1:input_size(2)),compare_template,iteration,std_template,mean_template);
for trial = 2:length(fluct)
    ratio = fluct(trial);
    compare_template = imresize(input_template,ratio);
    size_template = size(compare_template);
    input_size = min(size_image,max(2*size_template,floor(size_image/2)));
    iteration = min(floor(min(log(input_size)/log(2)-6)),floor(min(log(input_size)/log(2)-5)));
    [test_fit_coor,test_fit_cc] = new_locate_levelup(input_image(1:input_size(1),1:input_size(2)),compare_template,iteration,std_template,mean_template);
    if test_fit_cc > best_fit_cc
        best_fit_cc = test_fit_cc;
        best_fit_coor = test_fit_coor;
        output_scale = fluct(trial);
    end
end
output = best_fit_coor;

end