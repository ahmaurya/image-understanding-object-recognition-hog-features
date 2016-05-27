function tl_detect_script

load('template_images_pos.mat');
load('template_images_neg.mat');

Itest = im2double(rgb2gray(imread('../data/test4.jpg')));
ndet = 1;
lambda = 1e-3;

template = tl_pos(template_images_pos);
[x,y,~] = detect(Itest,template,ndet);
draw_detection(Itest, ndet, x, y);

template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,~] = detect(Itest,template,ndet);
draw_detection(Itest, ndet, x, y);

template = tl_lda(template_images_pos, template_images_neg, lambda);
[x,y,~] = detect(Itest,template,ndet);
draw_detection(Itest, ndet, x, y);

template = tl_lda(template_images_pos, template_images_neg, lambda);
[x,y,~] = multiscale_detect(Itest, template, ndet);
draw_detection(Itest, ndet, x, y);


Itest = im2double(rgb2gray(imread('../data/multiple-signs-extreme.jpg')));
ndet = 25;
lambda = 1e-3;

template = tl_pos(template_images_pos);
[x,y,~] = detect(Itest,template,ndet);
draw_detection(Itest, ndet, x, y);

template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,~] = detect(Itest,template,ndet);
draw_detection(Itest, ndet, x, y);

template = tl_lda(template_images_pos, template_images_neg, lambda);
[x,y,~] = detect(Itest,template,ndet);
draw_detection(Itest, ndet, x, y);


Itest = im2double(rgb2gray(imread('../data/multiple-signs.jpg')));
ndet = 3;
lambda = 1e-3;

template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,scale] = multiscale_detect(Itest, template, ndet);
draw_detection(Itest, ndet, x, y, scale);

end

function draw_detection(Itest, ndet, x, y, scale)
    %display top ndet detections
    figure; clf; imshow(Itest);
    for i = 1:ndet
      % draw a rectangle.  use color to encode confidence of detection
      %  top scoring are green, fading to red
      hold on;
      if nargin < 5
          scale = ones(size(x,2),1);
      end
      h = rectangle('Position',[x(i)-round(100/scale(i)) y(i)-round(100/scale(i)) round(200/scale(i)) round(200/scale(i))],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
      hold off;
    end
end