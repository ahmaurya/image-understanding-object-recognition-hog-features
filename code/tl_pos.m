function template = tl_pos(template_images_pos)

image_size = size(template_images_pos{1});
template_size = [image_size/8, 9];
num_images_pos = size(template_images_pos,2);
template = zeros(template_size);

for i=1:num_images_pos
    pos_image = template_images_pos{i};
    template = template + hog(pos_image);
end

template = template/num_images_pos;

end