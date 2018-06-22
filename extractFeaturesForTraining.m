function [ featuresVar  ] = extractFeaturesForTraining(trainingPosDir,trainingNegDir,posFilenames,negFilenames)
 
I = imread(fullfile(trainingPosDir, posFilenames(1).name));
I1=rgb2gray(I);
I1=histeq(I1);
hogFeatrueVectorTemp=extractHOGFeatures(I1,'CellSize',[16 16],'BlockSize',[2 2]);
lbpFeaturesVectorTemp=extractLBPFeatures(I1);
 
[~,numOfFeatures]=size(hogFeatrueVectorTemp);
hogFeatures=zeros(length(posFilenames)+length(negFilenames),numOfFeatures);
hogFeatures(1,:)=hogFeatrueVectorTemp(1,:);
 
[~,numOfFeatures]=size(lbpFeaturesVectorTemp);
lbpFeatures=zeros(length(posFilenames)+length(negFilenames),numOfFeatures);
lbpFeatures(1,:)=lbpFeaturesVectorTemp(1,:);
 
 
for i = 2:length(posFilenames)
I = imread(fullfile(trainingPosDir, posFilenames(i).name));
I1=rgb2gray(I);
I1=histeq(I1);
hogFeatrueVectorTemp=extractHOGFeatures(I1,'CellSize',[16 16],'BlockSize',[2 2]);
hogFeatures(i,:)=hogFeatrueVectorTemp;
 
 
lbpFeaturesVectorTemp=extractLBPFeatures(I1);
lbpFeatures(i,:)=lbpFeaturesVectorTemp;
 
end
 
counter=length(posFilenames)+1;
for i = 1:length(negFilenames)
I = imread(fullfile(trainingNegDir, negFilenames(i).name));
I1=rgb2gray(I);
I2=imresize(I1,[96,160]);
I1=histeq(I1);
hogFeatrueVectorTemp=extractHOGFeatures(I2,'CellSize',[16 16],'BlockSize',[2 2]);
hogFeatures(counter,:)=hogFeatrueVectorTemp;
 
 
 
lbpFeaturesVectorTemp=extractLBPFeatures(I2);
lbpFeatures(counter,:)=lbpFeaturesVectorTemp;
counter=counter+1;
end
featuresVar=[hogFeatures lbpFeatures];
% featuresVar=[hogFeatures];
end