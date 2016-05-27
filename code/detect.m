function [x,y,score] = detection(I,template,ndet)

hogI = hog(I);
[hog_height, hog_width, num_bins] = size(hogI);

x = zeros(1,ndet);
y = zeros(1,ndet);
score = zeros(1,ndet);

response = zeros(hog_height, hog_width);
rotated_template = rot90(template,2);

for i=1:num_bins
    response = response + conv2(hogI(:,:,i), rotated_template(:,:,i), 'same');
end

% colormap winter
% imagesc(response)

[X,Y] = meshgrid(1:hog_width,1:hog_height);
columnar_response = [Y(:), X(:), response(:)];
sorted_response = sortrows(columnar_response, -3);
ndet_current = 0;

for i=1:size(sorted_response,1)
    y_ = 8*sorted_response(i,1);
    x_ = 8*sorted_response(i,2);
    score_ = sorted_response(i,3);
    distances = sqrt((y-y_).^2 + (x-x_).^2);
    num_overlaps = sum(distances < 80*sqrt(2));
    
    if (num_overlaps == 0)
        ndet_current = ndet_current + 1;
        y(ndet_current) = y_ - 4;
        x(ndet_current) = x_ - 4;
        score(ndet_current) = score_;
    end
    
    if (ndet_current >= ndet)
        break
    end
end
