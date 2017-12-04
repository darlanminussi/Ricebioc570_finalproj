% final_proj_single_file reads only 4 images that contain the same file
% name. 
% Current folder has to be the one that contain the images unless
% specified on readimages

% addpath is used to execute the functions without being on the current
% folder. Please change to the appropriate one if needed.
addpath('..');

img = {};
% reading a sequence of images
img = readimages_v1('t0088_z01_w%d.tif', 3);

% showing DAPI channel
imshow(img{1}, []);
 
imask = {};
% creating masks
% processing to erode and eliminate false positives
% filling holes for better cd45 detection
for i = 1:4
    imask{i} = img{i} > 400;
    imask{i} = imopen(imask{i}, strel('disk', 4));
    imask{i} = imfill(imask{i},'holes');
end

% detecting ctcs
% Channel 1 = & DAPI 
% Channel 2 = & CK
% Channel 3 = NOT CD45
% Channel 4 = & EpCAM
ctc = imask{1} == 1 & imask{2} == 1 & imask{3} == 0 & imask{4} == 1;
imshow(ctc);


% finding centroids and bounding boxes (rectangles of each CTC)
istats = regionprops(ctc,'centroid', 'BoundingBox');
positions = cat(1, istats.Centroid);
boundingb = istats.BoundingBox;

% plotting bounding box rectangle
imshow(img{1},[]); hold on;
rectangle('Position', boundingb,...
	'EdgeColor','r', 'LineWidth', 1)

% plotting markers over ctcs positions
ctc_position = struct2cell(istats);
ctc_position = cellfun(@transpose, ctc_position, 'UniformOutput',false);
ctc_position = cell2mat(ctc_position); 

imshow(img{1},[]); hold on;
plot(ctc_position(1,:), ctc_position(2,:), 'g+', 'MarkerSize', 10);

% measuring properties of found ctcs
imask_dapi = imask{1};

area = {};
majoraxis = {};
minoraxis = {};
image = {};
perimeter = {};
eccentricity = {};

[area, majoraxis, minoraxis, image, perimeter, eccentricity] = ctcprops(istats, imask_dapi);

disp(area);
disp(minoraxis);
disp(majoraxis)
disp(perimeter);
disp(eccentricity);





