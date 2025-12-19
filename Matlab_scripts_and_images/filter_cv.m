% Sobel filter (horizontal)
% sobel = fspecial('sobel');
% apply_filter_extended('cameraman.tif', sobel, true);

% Laplacian filter
% lap = fspecial('laplacian', 0.2);
% apply_filter_extended('cameraman.tif', lap, false);

% Custom sharpening filter
sharp = [0 -1 0; -1 5 -1; 0 -1 0];
image=apply_filter_extended('couple.bmp', sharp, true);

image_input = imread('couple.bmp');

img_hdl = imread('out_image.bmp');

% % Gaussian blur
% gauss = fspecial('gaussian', [3 3], 2.0);
% apply_filter_extended('cameraman.tif', gauss, false);

