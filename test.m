%frames;
%srcFiles = dir('E:\CS\GP\start\GP edit gui\gp\frames\*.jpg');
srcFiles = dir('E:\CS\GP\start\GP edit gui\gp\training_videos\Entering From Window and Stealing Object_frames\');
inCreaseFrameBy=10;
for i = 1:inCreaseFrameBy:length(srcFiles)
filename = strcat('E:\CS\GP\start\GP edit gui\gp\training_videos\Entering From Window and Stealing Object_frames\',num2str(i),'.jpg');
filename2 = strcat('E:\CS\GP\start\GP edit gui\gp\training_videos\Entering From Window and Stealing Object_frames\',num2str(i+inCreaseFrameBy),'.jpg');
I = imread(filename);
I2 = imread(filename2);
testImage=Motion_Detection(I,I2);
se = strel('rectangle',[80 60]);
closeBW = imclose(testImage,se);
%subplot(4,3,5),imshow(closeBW); title('closed');
BW = im2bw(closeBW,0.5);
%subplot(4,3,6),imshow(BW); title('BW');
[labeledImage, ] = bwlabel(BW);
rp = regionprops(labeledImage,'BoundingBox' ,'area');
[~,idx]=sort([rp.Area],'descend');
rp=rp(idx);
imshow(I2); title('original');
for k=1:length(rp)
    currentBB=rp(k).BoundingBox;
    rectangle('Position',[currentBB(1),currentBB(2),currentBB(3),currentBB(4)], 'EdgeColor','r','LineWidth',2 )
end
drawnow
end