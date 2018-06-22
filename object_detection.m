function [ R ] = object_detection( I,ref )
if (ndims(I)==3)
    I=rgb2gray(I);
end
if (ndims(ref)==3)
    ref=rgb2gray(ref);
end
I=adaptivethreshold(I,15,0.02,0);
ref=adaptivethreshold(ref,15,0.02,0);
R=imsubtract(I,ref);

%[~,w]=size(R);
% se = strel('line',6,w);
% R = imopen(R,se);
R = bwareaopen(R,100);
%{
[h,w]=size(R);
se = strel('line',5,w);
R = imopen(R,se);
se = strel('line',5,w*0.15);
R = imclose(R,se);
%}
se = strel('rectangle',[40 40]);
R=imfill(R,'holes');
R = imclose(R,se);

% [h,w]=size(R);
% for y=1:h
%     for x=1:w
%         if R(y,x)>130
%             R(y,x)=255;
%         else
%             R(y,x)=0;
%         end
%     end
% end


end

