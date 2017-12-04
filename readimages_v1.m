function img_data = readimages_v1(file_name_pattern, nfiles)
% input file_name_pattern: name of the file in quotes including %d in place
% of number
% input nfiles number of files to be read minus 1
% output: cell with all the images

img_data = cell(1, nfiles);

for ii = 0:nfiles
    filename = sprintf(file_name_pattern, ii);
    img_data{ii+1} = imread(filename);
end

end

