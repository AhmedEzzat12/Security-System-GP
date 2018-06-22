function accuracy= test_ml(svmStruct)
 
%svmStruct=trainModel();
%% Testing
testingPosDir ='INRIAPerson\Test\pos';
posFilenames = dir(fullfile(testingPosDir, '*.png'));
 
testingNegDir ='INRIAPerson\Test\neg';
negFilenames = dir(fullfile(testingNegDir, '*.png'));
 
classVector=zeros(length(posFilenames)+length(negFilenames),1);
classVector(1:length(posFilenames),:)=1;
 
confusionMatrix=zeros(2,2);
for i=1:length(posFilenames)
    I = imread(fullfile(testingPosDir, posFilenames(i).name));
    isHuman=classifyUsingSVM(I,svmStruct);
    if isHuman==1
        confusionMatrix(2,2)=confusionMatrix(2,2)+1;
    end
end
 
for i=1:length(negFilenames)
    I = imread(fullfile(testingNegDir, negFilenames(i).name));
    isHuman=classifyUsingSVM(I,svmStruct);
    if isHuman==0
        confusionMatrix(1,1)=confusionMatrix(1,1)+1;
    end
end
 
res=sum(diag(confusionMatrix));
accuracy=(res/(length(posFilenames)+length(negFilenames)))*100;
 
end