function dec_vals = binvec2dec(bin_vec)
    % Converts cell array of binary strings to decimal values
    dec_vals = zeros(length(bin_vec), 1);
    for i = 1:length(bin_vec)
        dec_vals(i) = bin2dec(bin_vec{i});
    end
end