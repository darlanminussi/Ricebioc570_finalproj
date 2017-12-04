function img_data = readimages(directory)
% input directory: folder with all the image files. Only .tif files will be
% read
% output: cell array containing all the images

files = dir(directory);

filenames = {};

% saving to a cell vector
for i = 1:numel(files)
    filenames{i} = files(i).name;
end

% removing non .tif files
filenames_filtered = {};

for j = 1:numel(filenames)
if contains(filenames{j}, '.tif') == 1
    filenames_filtered{j} = filenames{j};
else
end
end

% filtering empty cells
 filenames_filtered = filenames_filtered(~cellfun('isempty',filenames_filtered));  

% removing .tif
for ii = 1:numel(filenames_filtered)
filenames_filtered{ii} = extractBefore(filenames_filtered{ii}, '.tif');
end

% removing number after w
filenames_filtered = cellfun(@(filenames_filtered) filenames_filtered(1:end-1), filenames_filtered, 'Uniform', 0);

% keeping unique names
filenames_filtered = unique(filenames_filtered);


img_data = {};

% reading images and putting into a cell
for jj = 1:numel(filenames_filtered)
for ii = 0:3
    
    filename = sprintf('%s%d%s', filenames_filtered{jj},ii,'.tif');
    img_data{end + 1} = imread(sprintf('%s/%s', directory,filename));
    
    end
end
