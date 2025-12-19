function bin_lines = read_bin_file(filename)
    fprintf('Trying to read file: %s\n', filename);
    fid = fopen(filename, 'r');
    if fid == -1
        error('? ERROR: Could not open file: %s\n??  Check path, filename, or permissions.', filename);
    end
    bin_lines = textscan(fid, '%s');
    fclose(fid);
    bin_lines = bin_lines{1};
end
