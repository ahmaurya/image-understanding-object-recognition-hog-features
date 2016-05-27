pos_image_names = {'../data/test0.jpg','../data/test1.jpg','../data/test2.jpg','../data/test3.jpg','../data/test4.jpg','../data/test5.jpg','../data/multiple-signs-extreme.jpg'};
neg_image_names = {'../data/control0.jpg','../data/control1.jpg','../data/control2.jpg','../data/control3.jpg'};

template_images_pos = {};
template_images_neg = {};

num_clicks = 1;
avg_width = 0;
avg_height = 0;
count = 0;

for i=1:size(pos_image_names,2)
    Itrain = imread(pos_image_names{i});
    Itrain = im2double(rgb2gray(Itrain));

    figure(1); clf;
    imshow(Itrain);
    
    for j=1:num_clicks
        rect = getrect;
        x = rect(1);
        y = rect(2);
        width = rect(3);
        height = rect(4);

        patch = Itrain(y:y+height,x:x+width);
        avg_height = avg_height + size(patch,1);
        avg_width = avg_width + size(patch,2);
        count = count + 1;
        
        idx = size(template_images_pos,2)+1;
        template_images_pos{idx} = patch;
    end
    close(gcf);
end

for i=1:size(neg_image_names,2)
    Itrain = imread(neg_image_names{i});
    Itrain = im2double(rgb2gray(Itrain));

    figure(1); clf;
    imshow(Itrain);
    
    for j=1:num_clicks
        rect = getrect;
        x = rect(1);
        y = rect(2);
        width = rect(3);
        height = rect(4);

        patch = Itrain(y:y+height,x:x+width);
        avg_height = avg_height + size(patch,1);
        avg_width = avg_width + size(patch,2);
        count = count + 1;

        idx = size(template_images_neg,2)+1;
        template_images_neg{idx} = patch;
    end
    close(gcf);
end

avg_height = 1.0*avg_height/count;
avg_height = avg_height + 8 - rem(avg_height,8);
avg_width = 1.0*avg_width/count;
avg_width = avg_width + 8 - rem(avg_width,8);

for i=1:size(template_images_pos,2)
    template_images_pos{i} = imresize(template_images_pos{i}, [avg_height, avg_width]);
end

for i=1:size(template_images_neg,2)
    template_images_neg{i} = imresize(template_images_neg{i}, [avg_height, avg_width]);
end

save('template_images_pos.mat','template_images_pos');
save('template_images_neg.mat','template_images_neg');
