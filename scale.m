function output = scale(temp_in,ref_in);
%aims to scale the temp and ref
%works for dim2 only
%should be used with chan vese
%template,reference

%initialization
%temp = imread(temp_in);
%ref = imread(ref_in);
temp = temp_in;
ref = ref_in;
size_temp = size(temp); 
size_ref = size(ref); 
prescale_temp = min(size_temp/500);
prescale = min(size_ref/250);
temp = imresize(temp,1/prescale_temp);
ref = imresize(ref,1/prescale);
size_temp = size(temp);
size_ref = size(ref);
%check whether RGB or not, somehow rgb2gray doesn't work
if length(size_temp) == 3    
    temp = temp(:,:,1);
end
if length(size_ref) == 3
    ref = ref(:,:,1);
end

%create mask
mask_temp = zeros(size_temp);
mask_temp(temp<mean(mean(temp))) = 0;
mask_temp(temp>=mean(mean(temp))) = 1;

mask_ref = zeros(size_ref);
mask_ref(ref<mean(mean(temp))) = 0;
mask_ref(ref>=mean(mean(temp))) = 1;

temp = im2double(mask_temp);
ref = im2double(mask_ref);

%Since the performance is the best when the ref size is about 200*200, we
%rescale it
%ref = imresize(ref,200*((1/size_ref(1))*size_ref));


%the function of 'eating' as a time parameter
    function output_scale_test = scale_test(input_scale_test,tol)
        output_scale_test = tol;
        tolerance = 10;
        while sum(sum(input_scale_test)) > tolerance
            input_scale_test = conv2(input_scale_test,[1/8,1/8,1/8;1/8,0,1/8;1/8,1/8,1/8],'same');
            input_scale_test(input_scale_test<1) = 0;
            output_scale_test = output_scale_test + 1;
            %imshow(input_scale_test);
            %pause(0.01);
        end
    end

%rescale the picture
noise_mean = 0;
scale_temp = scale_test(imresize(temp(1:min(size_temp(1),2*size_ref(1)),1:min(size_temp(1),2*size_ref(2))),3),noise_mean);
scale_ref = scale_test(imresize(ref,3),noise_mean);
output = (scale_ref/scale_temp)*prescale/prescale_temp

%ref_in = imread(ref_in);
%output = imresize(ref_in,scale_temp/scale_ref);
end
