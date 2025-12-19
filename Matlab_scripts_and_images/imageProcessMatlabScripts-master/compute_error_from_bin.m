function compute_error_from_bin(exact_out, approx_out)
% Calculate error metrics between exact and approximate outputs
% Inputs:
%   exact_out  : array of exact outputs (decimal values)
%   approx_out : array of approximate outputs (same length)

    % Ensure inputs are column vectors
    exact_out  = exact_out(:);
    approx_out = approx_out(:);
    abs_error = 0; 
    if length(exact_out) ~= length(approx_out)
        error('Exact and Approximate arrays must be the same length.');
    end

    N = length(exact_out);
    bit_width = ceil(log2(max([exact_out; approx_out]) + 1)); % auto-detect

    %% Error Calculations
%     abs_error = abs(double(exact_out) - double(approx_out));
    for i=1:N 
        if(abs(double(exact_out)-double(approx_out))~=0); 
            abs_error= abs_error +1; 
        end 
    end 
    
    rel_error = abs_error ./ (double(exact_out) + (exact_out == 0));  % avoid /0

    % Metrics
%     ER     = sum(abs_error > 0) / N;                    % Error Rate
    ER     = abs_error/ N;                    % Error Rate
    MED    = mean(abs_error);                           % Mean Error Distance
    NMED   = MED / (2^bit_width - 1);                   % Normalized MED
    MRED   = mean(rel_error);                           % Mean Relative Error
    MaxED  = max(abs_error);                            % Max Error
    COR    = 1 - ER;                                    % Correct Output Ratio
    VAR_ED = var(abs_error);                            % Error Variance

    %% Print Results
    fprintf('\n===== Error Metrics =====\n');
    fprintf('Bit Width (Auto-detected): %d bits\n', bit_width);
    fprintf('Total Samples: %d\n', N);
    fprintf('Error Rate (ER):            %.4f\n', ER);
    fprintf('Mean Error Distance (MED):  %.2f\n', MED);
    fprintf('Normalized MED (NMED):      %.6f\n', NMED);
    fprintf('Mean Relative Error (MRED): %.4f\n', MRED);
    fprintf('Max Error Distance:         %d\n', MaxED);
    fprintf('Correct Output Ratio (COR): %.4f\n', COR);
    fprintf('Error Variance:             %.2f\n', VAR_ED);

    %% Optional Plot
    figure;
    histogram(abs_error, 'BinWidth', 1);
    title('Error Distance Histogram');
    xlabel('Absolute Error');
    ylabel('Frequency');
    grid on;
end
