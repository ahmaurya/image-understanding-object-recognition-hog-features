function template = tl_pos_neg(template_images_pos, template_images_neg)

image_size = size(template_images_pos{1});
template_size = [image_size/8, 9];

num_images_pos = size(template_images_pos,2);
num_images_neg = size(template_images_neg,2);

template_pos = zeros(template_size);
template_neg = zeros(template_size);

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

template = template_pos - template_neg;

end