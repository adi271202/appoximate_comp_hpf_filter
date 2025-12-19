function filtered_img = apply_filter_extended(image_path, kernel, save_output)
    % Read the image
    img = imread(image_path);

    % Check if the image is grayscale or color
    isColor = size(img, 3) == 3;

    if isColor
        % Initialize output image
        filtered_img = zeros(size(img));
        for ch = 1:3
            % Apply filter to each channel
            filtered_img(:,:,ch) = imfilter(double(img(:,:,ch)), kernel, 'replicate');
        end
        % Convert to uint8 for saving and display
        filtered_img = uint8(filtered_img);
    else
        % Grayscale case
        filtered_img = imfilter(double(img), kernel, 'replicate');
        filtered_img = uint8(filtered_img);
    end

    % Show original and filtered image
    figure;
    subplot(1,2,1);
    imshow(img);
    title('Original Image');

    subplot(1,2,2);
    imshow(filtered_img);
    title('Filtered Image');

    % Save output image if required
    if nargin > 2 && save_output
        [~, name, ~] = fileparts(image_path);
        outname = [name '_filtered.bmp'];
        imwrite(filtered_img, outname);
        fprintf('Filtered image saved as: %s\n', outname);
    end
end
