% final_proj_read_directory
% Reads all the file from one directory.
% current folder has to be the one with all the functions and NOT the one
% with the images

addpath('..');

img = {};
% reading a sequence of images
img = readimages('BH01_20170616_163650_61_NONE_dcm_cf22_P_20170616_192322_TIFF');
 
imask = {};
% creating masks
% processing to erode and eliminate false positives
% filling holes for better cd45 detection
for i = 1:numel(img)
    imask{i} = img{i} > 400;
    imask{i} = imopen(imask{i}, strel('disk', 4));
    imask{i} = imfill(imask{i},'holes');
end

% detecting ctcs
% Channel 1 = & DAPI 
% Channel 2 = & CK
% Channel 3 = NOT CD45
% Channel 4 = & EpCAM

factor = numel(img)/4;
reshape_vector = 1:numel(img);
reshape_matrix = reshape(reshape_vector, [4 factor]);
reshape_matrix = transpose(reshape_matrix);

ctc = {};

for ii = 1:size(reshape_matrix,1)

    ctc{ii} = imask{reshape_matrix(ii,1)} == 1 & imask{reshape_matrix(ii,2)} == 1 & imask{reshape_matrix(ii,3)} == 0 & imask{reshape_matrix(ii,4)} == 1;
 
end

% finding centroids and bounding boxes (rectangles of each CTC)

istats = {};
positions = {};

for i = 1:numel(ctc)
istats{i} = regionprops(ctc{i},'centroid', 'BoundingBox');
positions{i} = cat(1, istats{1}.Centroid);
end

% measuring properties of found ctcs
imask_dapi = {};

for i = 1:size(reshape_matrix,1)
imask_dapi{i} = imask{reshape_matrix(i,1)};
end

area = {};
majoraxis = {};
minoraxis = {};
image = {};
perimeter = {};
eccentricity = {};

for i = 1:numel(imask_dapi)
[area{i}, majoraxis{i}, minoraxis{i}, image{i}, perimeter{i}, eccentricity{i}] = ctcprops(istats{i}, imask_dapi{i});
end

% collecting statistics
area_a = cell2mat(area);
minoraxis_a = cell2mat(minoraxis);
majoraxis_a = cell2mat(majoraxis);
perimeter_a = cell2mat([perimeter{:}]);
eccentricity_a = cell2mat([eccentricity{:}]);
ctc_number = numel(area_a);
