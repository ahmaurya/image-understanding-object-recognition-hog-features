function template = tl_lda(template_images_pos, template_images_neg, lambda)

num_bins = 9;

image_size = size(template_images_pos{1});
template_size = [image_size/8, num_bins];

num_images_pos = size(template_images_pos,2);
num_images_neg = size(template_images_neg,2);

template_pos = zeros(template_size);
template_neg = zeros(template_size);
template = zeros(template_size);
cov_neg = zeros(template_size(1), template_size(1), 9);

for i=1:num_images_pos
    pos_image = template_images_pos{i};
    template_pos = template_pos + hog(pos_image);
end

template_pos = template_pos/num_images_pos;

for i=1:num_images_neg
    neg_image = template_images_neg{i};
    template_neg = template_neg + hog(neg_image);
end

template_neg = template_neg/num_images_neg;

for i=1:num_images_neg
    hog_neg = hog(template_images_neg{i}) - template_neg;
    for j=1:num_bins
        cov_neg(:,:,j) = cov_neg(:,:,j) + hog_neg(:,:,j)*hog_neg(:,:,j)';
    end
end

for i=1:num_bins
    euclidean_transform = cov_neg(:,:,i)/num_images_neg + lambda*eye(template_size(1));
    template(:,:,i) = euclidean_transform\(template_pos(:,:,i) - template_neg(:,:,i));
end

end