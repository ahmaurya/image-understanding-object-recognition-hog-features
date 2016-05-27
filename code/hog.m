function ohist = hog(I)

if (ndims(I)==3)
    I = rgb2gray(I);
end
I = im2double(I);

[mag,ori] = mygradient(I);
thresh = 0.1*max(mag(:));
mag_cond = mag > thresh;
ori_cond = ori ~= 0.0;
num_bins = 9;

[height,width] = size(I);
hog_height = ceil(height/8);
hog_width = ceil(width/8);

ohist = zeros(hog_height,hog_width,num_bins);
ohist_norm = zeros(hog_height,hog_width,num_bins);

for i=1:num_bins
    min_orientation = -pi + (i-1)*2*pi/num_bins;
    max_orientation = -pi + i*2*pi/num_bins;
    cond = mag_cond & ori_cond & (ori >= min_orientation) & (ori < max_orientation);
    cond_column = im2col(cond, [8,8], 'distinct');
    cond_column = reshape(sum(cond_column), hog_height, hog_width);
    ohist(:,:,i) = cond_column;
end

ohist_sum = sum(ohist,3);
ohist_sum = ohist_sum + (ohist_sum==0);
for i=1:num_bins
    ohist_norm(:,:,i) = ohist_sum;
end
ohist = ohist./ohist_norm;
