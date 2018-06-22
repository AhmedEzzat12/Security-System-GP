function isHuman = classifyUsingSVM( testImage,svmStruct )
I1=rgb2gray(testImage);
I2=imresize(I1,[96,160]);
I2=histeq(I2);
hogFeatrueVectorTemp=extractHOGFeatures(I2,'CellSize',[16 16],'BlockSize',[2 2]);
lbpFeaturesVectorTemp=extractLBPFeatures(I2);
testImageF=[hogFeatrueVectorTemp lbpFeaturesVectorTemp];
isHuman = predict(svmStruct,testImageF);
end