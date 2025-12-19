imageWidth = 256;
imageHeight = 256;
numColor = 1;

p=imread('cameraman.bmp');
fileID = fopen('cameraman_bin.bin','w');
for r = 1:imageHeight
    for c = 1:imageWidth
        for m = 1:numColor
            fwrite(fileID,p(r,c,m));
        end
    end
end
fclose(fileID);