% data analysis.
% Since the images size were too large to transfer to github I'm providing
% the workspace with the analysis for the 30 image panel dataset

load('final_project_analysis_workspace.mat');

% array with the CTCs area values
disp(ctc_area);
% array with the CTCs eccentricity values
disp(ecc);
% array with the WBCs area values
disp(area_wbc);
% array with the WBCs eccentricity values
disp(ecc_wbc);

histogram(ctc_area, 30);
xlabel('Area');
ylabel('Frequency');

histogram(ecc, 30, 'FaceColor', 'k');
xlabel('Eccentricity');
ylabel('Frequency');

scatter(ctc_area, ecc);
xlabel('Eccentricity');
ylabel('Area');

% small correlation between area and eccentricity
R = corrcoef(ctc_area, ecc)

% area_wbc = regionprops(imask{99}, 'Area', 'Eccentricity')
% area_wbc = [area_wbc.Area];
mean_areawbc = mean(area_wbc)
std_wbc = std(area_wbc)

% number of Wbcs in the dataset
numel(area_wbc)

ctc_area_mean = mean(ctc_area);


% ecc_wbc = [area_wbc.Eccentricity];
mean_eccwbc = mean(ecc_wbc);

mean(ecc)

% area plot
scatter(repelem(1, numel(ctc_area)), ctc_area); hold on;
scatter(repelem(2, numel(area_wbc)), area_wbc)
xlim([0.5 2.5]);
xticklabels({'.','CTC','.','WBC','.'});
ylabel('Area');

% eccentricity plot
scatter(repelem(1, numel(ecc)), ecc); hold on;
scatter(repelem(2, numel(ecc_wbc)), ecc_wbc)
xlim([0.5 2.5]);
xticklabels({'.','CTC','.','WBC','.'});
ylabel('Eccentricity');

% significant tests
[r, p] = ttest2(ecc, ecc_wbc);
[h,p2] = ttest2(area_a, area_wbc)