clear all;
clc;

fps = 6000; %frame rate
scale = 11/0.3; % pixels/mm

for i=1:21
    images(:,:,:,i) = imread(sprintf('side%04d.jpg',i));
end

numframes = size(images, 4);

for k = numframes:-1:1
    g(:, :, k) = rgb2gray(images(:, :, :, k));
end

gDil = imdilate(g,ones(1,1,10));

for k = numframes:-1:1
    d(:,:,k) = imabsdiff(g(:,:,k),gDil(:,:,k));
    img_num(:, :, k) = im2double(d(:, :, k));
    dBW(:,:,k) = im2bw(d(:,:,k),0.05); %0.1 for front
    dBWclean(:,:,k) = bwareaopen(dBW(:,:,k),10,8);
end

centroids = zeros(numframes, 2);

for k = 1:numframes
    L = bwlabel(dBWclean(:, :, k));
    s = regionprops(L, 'area', 'centroid','perimeter','MajorAxisLength','MinorAxisLength','convexArea','BoundingBox');
    area_vector = [s.Area];
    [tmp, idx] = max(area_vector);
    
    box(k, :) = floor(s(idx).BoundingBox);
    centroids(k, :) = s(idx).Centroid;
    perimeter(k, :) = s(idx).Perimeter;
    minor(k, :) = s(idx).MinorAxisLength;
    major(k, :) = s(idx).MajorAxisLength;
    convex(k,:) = s(idx).ConvexArea;
end

for k=1:numframes
    for i = box(k,1) : box(k,1)+box(k,3)
        for j = box(k,2) : box(k,2)+box(k,4)
            [I(k),Imax(k)] = circularHough(img_num(:,:,k), i, j, 15, 25);
        end
    end
end

%rectangle('Position',[centroids(10,1)-8,centroids(10,2)-8,20,20],'EdgeColor','b')
