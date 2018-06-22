function svmStruct= trainModel()
 
trainingPosDir ='INRIAPerson\Train\pos';
posFilenames = dir(fullfile(trainingPosDir, '*.png'));
 
trainingNegDir ='INRIAPerson\Train\neg';
negFilenames = dir(fullfile(trainingNegDir, '*.png'));
 
classVector=zeros(length(posFilenames)+length(negFilenames),1);
classVector(1:length(posFilenames),:)=1;
 
[ featuresMatrix  ] = extractFeaturesForTraining( trainingPosDir,trainingNegDir,posFilenames,negFilenames);
svmStruct = fitcsvm(featuresMatrix,classVector,'KernelFunction','RBF',...
'ClassNames',[1 0]);
 
end