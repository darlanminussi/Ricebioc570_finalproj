function [out_area, out_majoraxis, out_minoraxis, out_image, out_perimeter, out_eccentricity] = ctcprops(struct, imask_dapi)
% input struct: struct with the intersect files that detected ctcs
% input imask_dapi: imas of only the dapi channel
% output: different morphometric data from the identified CTCs based on the
% dapi_channel


ctc_stats = {};
out_image = {};
thisBB = [];
out_area = [];
out_majoraxis = [];
out_minoraxis = [];
out_eccentricity = {};
out_perimeter = {};
out_image = {};

for i = 1:numel(struct)
    thisBB = struct(i).BoundingBox;
    
    % Scale the rectangle to 1.2 times its original size
    scale = 4;
    
    % Adjust the lower left corner of the rectangles
    thisBB(:,1:2) = thisBB(:,1:2) - thisBB(:,3:4)*0.5*(scale - 1);
    
    % Adjust the width and height of the rectangles
    thisBB(:,3:4) = thisBB(:,3:4)*scale;
    
    dapi_crop = imcrop(imask_dapi,[thisBB(1),thisBB(2),thisBB(3),thisBB(4)]);
    
    ctc_stats{i} = regionprops(dapi_crop,'Image', 'Area', 'MajorAxisLength', 'MinorAxisLength', 'Perimeter', 'Eccentricity');
    
    out_area(i) = ctc_stats{i}.Area;
    out_majoraxis(i) = ctc_stats{i}.MajorAxisLength;
    out_minoraxis(i) = ctc_stats{i}.MinorAxisLength;
    out_image{i} = ctc_stats{i}.Image;
    out_perimeter{i} = ctc_stats{i}.Perimeter;
    out_eccentricity{i} = ctc_stats{i}.Eccentricity;
    
end

end

