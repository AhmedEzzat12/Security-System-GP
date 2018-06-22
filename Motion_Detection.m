function [R,Refrence,k] = Motion_Detection( I1,I2,Refrence_Frame,k,VideoPath)

if(ndims(I1)==3)
    I1=rgb2gray(I1);
end
RR=I1;

%I1=histeq(I1);
if (ndims(I2)==3)
    I2=rgb2gray(I2);
end
%I2=histeq(I2);
I1=adaptivethreshold(I1,15,0.02,0);
I2=adaptivethreshold(I2,15,0.02,0);
if (ndims(Refrence_Frame)==3)
    Refrence_Frame=rgb2gray(Refrence_Frame);
end
Ref=Refrence_Frame;
Refrence_Frame=histeq(Refrence_Frame);
Refrence_Frame=im2bw(Refrence_Frame);
[h,w]=size(Refrence_Frame);
count =0;
count1=0;
for i=1:h
    for j=1:w
        if Refrence_Frame(i,j)==1
            count=count+1;
        end
    end
end
R=imsubtract(I1,I2);
[h,w]=size(R);
% for y=1:h
%     for x=1:w
%         if R(y,x)>130
%             R(y,x)=255;
%         else
%             R(y,x)=0;
%         end
%     end
% end

for i=1:h
    for j=1:w
        if R(i,j)==1
            count1=count1+1;
        end
    end
end
if count1>=count
    Refrence=Ref;
else
    Refrence=Ref;
    %%%%%%%%%%%%% save 
    [path,vidname,~]=fileparts(VideoPath);
    resfile=strcat(path,'\',vidname,'_frames\reference');
    filename=strcat(num2str(k),'.jpg');
    fullFileName = fullfile(resfile, filename);
    
    k=k+1;
end
R = bwareaopen(R,100);
se = strel('rectangle',[40 40]);
R=imfill(R,'holes');
R = imclose(R,se);
end