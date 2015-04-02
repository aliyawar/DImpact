clear all;
clc;
addpath('/media/yawar/PENSIEVE/March 15/3deg/H57/Side');
fps = 5450; %frame rate
scale = 11/0.3; % pixels/mm

for i=1:160
    images(:,:,:,i) = imread(sprintf('side%04d.jpg',i));
end

numframes = size(images, 4);

for k = numframes:-1:1
    g(:, :, k) = rgb2gray(images(:, :, :, k));
end

gDil = imdilate(g,ones(1,1,5));
h = fspecial('average',[3 3]);
fudgeFactor = .3; %0.3
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

for k = numframes:-1:1
    d(:,:,k) = imabsdiff(g(:,:,k),gDil(:,:,k));
    df(:,:,k) = imfilter(d(:,:,k), h);
    %img_num(:, :, k) = im2double(d(:, :, k));
    dBW(:,:,k) = im2bw(df(:,:,k),0.6*graythresh(df(:,:,k))); %0.1 for front
    %[~, threshold] = edge(dBW(:,:,k), 'sobel');
    
    %BW(:,:,k) = edge(df(:,:,k),'sobel', threshold * fudgeFactor);
    %BW(:,:,k) = bwareaopen(BW(:,:,k),2,8);
    %BW = imdilate(BW, [se90 se0]);
    dBW(:,:,k) = im2double(dBW(:,:,k));
    dBWclean(:,:,k) = bwareaopen(dBW(:,:,k),5,8);
end

centroids = zeros(numframes, 2);
centers = [];
data = struct();
radii = [];
image = [];
width = 16;
for k = 1:numframes
    L = bwlabel(dBWclean(:, :, k));
    s = regionprops(L, 'area', 'centroid', 'MinorAxisLength','MajorAxisLength','Orientation','Image','BoundingBox');
    %minor_axis = [s.MinorAxisLength];
    %major_axis = [s.MajorAxisLength];
    area = [s.Area];
    [tmp, idx] = max(area);
    %[center, radius] = imfindcircles(df(:,:,k),[15,25]);
    
    %if size(center,1) > 1
     %   [radius, idx] = max(radius);
      %  center = center(idx,:);
    %end
     %   centers = [centers; center];
     %   radii = [radii; radius];
    %box(k, :) = floor(s(idx).BoundingBox);
    centroids(k, :) = s(idx).Centroid;
%     perimeter(k, :) = s(idx).Perimeter;
    minor(k, :) = s(idx).MinorAxisLength;
    major(k, :) = s(idx).MajorAxisLength;
%     convex(k,:) = s(idx).ConvexArea;
    orient(k,:) = s(idx).Orientation;
    %image = [image s(idx).Image];
    box(k,:) = s(idx).BoundingBox;
    %snapshot = s(idx).Image;
    data.(sprintf('frame%d', k)) = sweepLine(df(:,:,k),box(k,:),1);
end


% for k=1:numframes
%     box(k,:) = uint16([centroids(k,1)-width/2, centroids(k,2)-width/2, width, width]);
%     [X(k),Y(k),radius(k)] = circularHough(df(:,:,k),box(k,:), 18, 30); %g == img_num
% end

%rectangle('Position',[centroids(10,1)-8,centroids(10,2)-8,20,20],'EdgeColor','b')
