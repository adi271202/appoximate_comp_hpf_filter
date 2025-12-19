

fileIDIMAGE = fopen('2_bin.bin','r'); 
image= fread(fileIDIMAGE); 
fileID = fopen('2_out_bin.bin','r');
data=fread(fileID);
fileIDHalf = fopen('2_half_approx_out_bin.bin','r'); 
dataHalf=fread(fileIDHalf); 
fileID1 = fopen('2_afa1_out_bin.bin','r');
data1=fread(fileID1);
fileID2 = fopen('2_afa2_out_bin.bin','r');
data2=fread(fileID2);
fileID3 = fopen('2_afa3_out_bin.bin','r');
data3=fread(fileID3);

DEPTH = 256; 
imageWidth = DEPTH;
imageHeight = DEPTH;
numColor = 1;

imageData = uint8(zeros(imageWidth*imageHeight*numColor,1));
exactData = uint8(zeros(imageWidth*imageHeight*numColor,1));
halfData  = uint8(zeros(imageWidth*imageHeight*numColor,1));
appData1  = uint8(zeros(imageWidth*imageHeight*numColor,1));
appData2  = uint8(zeros(imageWidth*imageHeight*numColor,1));
appData3  = uint8(zeros(imageWidth*imageHeight*numColor,1));
l=1;
for i = 1:imageWidth %for i 0 to maxColumn
    for j = 1:imageHeight %for j 0 to maxRow
        for k = 1:numColor
            imageData(l+(k-1)*(imageWidth*imageHeight))  = image(imageWidth*(j-1)*numColor+(i-1)*numColor+k); 
            exactData(l+(k-1)*(imageWidth*imageHeight))  = data(imageWidth*(j-1)*numColor+(i-1)*numColor+k);  %newData[k] = imageData[maxColumn*j+i]
            halfData(l+(k-1)*(imageWidth*imageHeight))   = dataHalf(imageWidth*(j-1)*numColor+(i-1)*numColor+k);
            appData1(l+(k-1)*(imageWidth*imageHeight))   = data1(imageWidth*(j-1)*numColor+(i-1)*numColor+k);
            appData2(l+(k-1)*(imageWidth*imageHeight))   = data2(imageWidth*(j-1)*numColor+(i-1)*numColor+k);
            appData3(l+(k-1)*(imageWidth*imageHeight))   = data3(imageWidth*(j-1)*numColor+(i-1)*numColor+k);
            
        end
        l=l+1;
    end
end

fclose(fileID);
fclose(fileID3); 
% imshow(m); 
% Define image dimensions and number of color channels
% Define image dimensions and number of color channels
% Define image dimensions
dims = [imageHeight, imageWidth, numColor];

% Store data and titles
dataList = {
    'Original_Image', imageData;
    'Exact Image' , exactData; 
    'Half Exact', halfData; 
    'Approximated_Image_1', appData1;
    'Approximated_Image_2', appData2;
    'Approximated_Image_3', appData3;
};

% Display and save each image
for i = 1:size(dataList, 1)
    % Reshape the image
    img = reshape(dataList{i,2}, dims);

    % Show the image
    figure('Name', dataList{i,1}, 'NumberTitle', 'off');
    imshow(img);
    title(strrep(dataList{i,1}, '_', ' '), 'FontWeight', 'bold');

    % Save the image to a PNG file
    filename = [dataList{i,1}, '.png'];
    imwrite(im2uint8(img), filename);  % Ensure image is in uint8 format
end
%%%%%%%%%%%%%%%%=========ERROR==========================
% Setup
data_approx = {dataHalf, data1, data2, data3};  % your approx output arrays
labels      = {'dataHalf', 'data1', 'data2', 'data3'};  % corresponding names

num_designs = numel(data_approx);
metrics     = struct();  % to store MED, ER etc.
colors      = lines(num_designs);  % for plot coloring

figure;
hold on;
legends = {};

% Track best design
best_MED = Inf;
best_index = -1;

% Loop over all designs
for j = 1:num_designs
    exact = double(data(:));
    approx = double(data_approx{j}(:));
    error_vals = abs(exact - approx);

    % Compute metrics
    ER  = sum(error_vals > 0) / length(error_vals);
    MED = mean(error_vals);

    metrics(j).label = labels{j};
    metrics(j).ER    = ER;
    metrics(j).MED   = MED;

    % Check if this is best (lowest MED)
    if MED < best_MED
        best_MED = MED;
        best_index = j;
    end

    % Plot histogram
    histogram(error_vals, 'DisplayName', labels{j}, ...
        'FaceColor', colors(j,:), 'EdgeColor', 'none', 'FaceAlpha', 0.5);

    legends{end+1} = labels{j};

    % Save individual plot
    figure;
    histogram(error_vals, 'BinWidth', 1);
    title(sprintf('Error Histogram: %s', labels{j}));
    xlabel('Absolute Error');
    ylabel('Frequency');
    grid on;
    saveas(gcf, sprintf('histogram_%s.png', labels{j}));
    close;  % close after saving
end

% Final multi-AFA plot
title('Error Histogram - All Approximate Designs');
xlabel('Absolute Error');
ylabel('Frequency');
legend(legends, 'Location', 'northeast');
grid on;

% Highlight best design
fprintf('\n Best Performing AFA: %s (Lowest MED = %.2f)\n', ...
    labels{best_index}, best_MED);

% Save combined plot
saveas(gcf, 'combined_histogram_all_AFAs.png');



