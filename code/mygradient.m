function [mag,ori] = mygradient(I)

if (ndims(I)==3)
    I = rgb2gray(I);
end
I = im2double(I);

gradFilter = fspecial('prewitt');
dx = imfilter(I, gradFilter, 'replicate');
dy = imfilter(I, gradFilter', 'replicate');
mag = sqrt(dx.*dx + dy.*dy);
ori = atan2(dy, dx);


