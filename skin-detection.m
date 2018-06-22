function simg= skin(r_image) 
clc;
workspace
fontSize = 20;
 
%folder = 'C:\Users\manarty\Downloads\gp\try'; %fpath
%baseFileName ='1516.jpg';%'1391.jpg';
% Get the full filename, with path prepended.
%fullFileName = fullfile(folder, baseFileName);
currentimg=r_image;%imread(fullFileName); %capture the image of interest r_image ; %
% 
% subplot(2,2,1);
% imshow(currentimg);
% title('Original Image', 'FontSize', fontSize);
 
%Read the image, and capture the dimensions
VidImage = currentimg;
height = size(VidImage,1);
width = size(VidImage,2);
 
%Initialize the output images
out = VidImage;
bin = zeros(height,width);
 
%Convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(VidImage);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);
 
%Detect Skin
[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
numind = size(r,1);
 
 
if (isnan(r))
    simg=0;
else 
    simg=1;
end
 
%Mark Skin Pixels
for i=1:numind
    out(r(i),c(i),:) = [0 0 255];
    bin(r(i),c(i)) = 1;
end
 
binaryImage=im2bw(bin,graythresh(bin));
binaryImage=~binaryImage;
% subplot(2,2,2); 
% imshow(binaryImage);
% title('Binary Image', 'FontSize', fontSize);
 
B = bwboundaries(binaryImage);
% imshow(binaryImage)
 
binaryImage = imfill(binaryImage, 'holes');
% Remove tiny regions.
binaryImage = bwareaopen(binaryImage, 5000);
% subplot(2,2,3);
% imshow(binaryImage);
% title('Second Binary Image', 'FontSize', fontSize);
 
%---------------------------------------------------------------------------
% Extract the largest area using ImageAnalyst's custom function ExtractNLargestBlobs().
 
biggestBlob = ExtractNLargestBlobs(binaryImage, 1);
 
% Display the image.
 
% subplot(2,2, 4);
% imshow(biggestBlob);
% title('Final Image', 'FontSize', fontSize);
 
%--------------------------------------------------------------------------
 
[labeledImage, numberOfBlobs] = bwlabel(biggestBlob, 8);
 
% Get all the blob properties.
blobMeasurements = regionprops(labeledImage, 'BoundingBox','Area');
allBlobAreas = [blobMeasurements.Area];
 
% Display the original gray scale image.
%   
%subplot(2,2,1);
% Loop through all blobs, putting up Bounding Box.
%hold on; % Prevent boxes from blowing away the image and prior boxes.
% 
% for k = 1 : numberOfBlobs
%       boundingBox = blobMeasurements(k).BoundingBox;   % Get box.
%       x1 = boundingBox(1);
%       y1 = boundingBox(2);
%       x2 = x1 + boundingBox(3) - 1;
%       y2 = y1 + boundingBox(4) - 1;
%       verticesX = [x1 x2 x2 x1 x1];
%       verticesY = [y1 y1 y2 y2 y1];
%       plot(verticesX, verticesY, 'r-', 'LineWidth', 2);
% end
%simg=biggestBlob;
%uiwait(msgbox('Done with demo'));
end
