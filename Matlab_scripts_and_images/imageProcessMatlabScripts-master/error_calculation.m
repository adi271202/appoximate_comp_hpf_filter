clc; 

fileIDIMAGE = fopen('2_out_bin.bin','r'); 
exact_file = fread(fileIDIMAGE); 

fileIDIMAGE1 = fopen('2_half_approx_out_bin.bin','r'); 
image1 = fread(fileIDIMAGE1); 

fileIDIMAGE2 = fopen('2_afa1_out_bin.bin','r'); 
image2 = fread(fileIDIMAGE2); 

fileIDIMAGE3 = fopen('2_afa2_out_bin.bin','r'); 
image3 = fread(fileIDIMAGE3); 

fileIDIMAGE4 = fopen('2_afa3_out_bin.bin','r'); 
image4 = fread(fileIDIMAGE4); 

fprintf('For Exact '); 
compute_error_from_bin(exact_file,exact_file);
fprintf('***********************************************************\n'); 

fprintf('For AFA1 '); 
compute_error_from_bin(exact_file,image2);
fprintf('***********************************************************\n'); 

fprintf('For AFA2 '); 
compute_error_from_bin(exact_file,image3);
fprintf('***********************************************************\n'); 

fprintf('For AFA3 '); 
compute_error_from_bin(exact_file,image4);
fprintf('***********************************************************\n'); 
