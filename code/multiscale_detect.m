function [x,y,scale] = multiscale_detect(I, template, ndet)

if (ndims(I)==3)
    I = rgb2gray(I);
end
I = im2double(I);

hogI = hog(I);
[hog_height, hog_width, ~] = size(hogI);

[template_height, template_width, ~] = size(template);

x = [];
y = [];
scale = [];
scores = [];

current_scale = 1.0;

while(hog_height > template_height && hog_width > template_width)
    [x_,y_,scores_] = detect(I, template, ndet);
    x = [x, round(x_/current_scale)];
    y = [y, round(y_/current_scale)];
    scores = [scores, scores_];
    scale = [scale, ones(1,ndet)*current_scale];
    
    I = imresize(I, 0.9);
    current_scale = current_scale*0.9;
    
    hogI = hog(I);
    [hog_height, hog_width, ~] = size(hogI);
end

columnar_response = [y',x',scores',scale'];
sorted_response = sortrows(columnar_response, -3);

x = zeros(1,ndet);
y = zeros(1,ndet);
scale = zeros(1,ndet);
ndet_current = 0;

for i=1:size(sorted_response,1)
    y_ = sorted_response(i,1);
    x_ = sorted_response(i,2);
    scale_ = sorted_response(i,4);
    distances = sqrt((y-y_).^2 + (x-x_).^2);
    num_overlaps = sum(distances < 200*sqrt(2)/scale_);
    
    if (num_overlaps == 0)
        ndet_current = ndet_current + 1;
        y(ndet_current) = y_ - 4;
        x(ndet_current) = x_ - 4;
        scale(ndet_current) = scale_;
    end
    
    if (ndet_current >= ndet)
        break
    end
end

%det_res = [x; y; scale]

end
