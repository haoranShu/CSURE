function [output,scaling] = SILocate(input_image,input_template);
input_size = min(size(input_image),max(2*size(input_template),floor(size(input_image))/2));
estimated = scale(input_image(1:input_size(1),1:input_size(2)),input_template);
estimated_scale = floor(10*estimated)/10;
estimated_min = estimated_scale - 0.2*(round(estimated_scale)+1);
estimated_max = estimated_scale + 0.3*(round(estimated_scale)+1);
[output,scaling] = ScaleSearch(input_image,input_template,1./[estimated_min:0.1:estimated_max]);
scaling = 1/scaling
end