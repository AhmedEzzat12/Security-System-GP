function ref=getRefernceFrame(directoryPath)
%{
directoryPath='E:\CS\GP\start\GP edit gui\gp\training_videos\Produce_0_frames\';
ref = strsplit(directoryPath,'\');
[~,ref_col]=size(ref);
ref=ref(ref_col-1);
directoryPath=regexprep(directoryPath,strcat(ref,'\'),'','ignorecase');
directoryPath=regexprep(directoryPath,strcat('training_videos','\'),'','ignorecase');
ref=regexprep(ref,'_frames','','ignorecase');
ref=strcat('2_',ref,'.jpg');
filename=fullfile(directoryPath,ref);
ref=imread(filename{1});%figure,imshow(ref);
%}
% directoryPath=regexprep(directoryPath,'.mp4','','ignorecase');
% directoryPath=strcat(directoryPath,'_frames/');
filename=fullfile(directoryPath,'2.jpg');
ref=imread(filename);%figure,imshow(ref);
end