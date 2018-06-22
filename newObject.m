function [checkValue,oldObjectPosition,movement,img]= newObject(img,movement,oldObjectPosition)
    [h,w]=size(img);
    checkValue=0;
    se = strel('line',20,w);
    img = imopen(img,se);
    se = strel('line',40,w*0.15);
    img = imclose(img,se);
    img=bwareaopen(img,7000);
    %BW = testImage;
    %[labeledImage, ] = bwlabel(BW);
    %img=bwareaopen(img,1300);
    connected_componentes=bwconncomp(img); % or use bwlabel
    %n_cc=connected_componentes.NumObjects;
    rp = regionprops(connected_componentes,'BoundingBox' ,'area');
    %remove object that have big width
    %{
    len=numel(rp);
    for i=1:len
        bb_i=ceil(rp(i).BoundingBox);
        if bb_i(3)>=w*0.85
            rectangle('Position',[bb_i(1),bb_i(2),bb_i(3),bb_i(4)],'EdgeColor','y','LineWidth',2 );
            minx=bb_i(2);
            maxx=bb_i(4)+minx;
            miny=bb_i(1);
            maxy=bb_i(3)+miny;
            %img(minx:maxx , miny:maxy)=0;
        end
    end
    %}
    %{
    BB = vertcat(rp.BoundingBox);
    if isempty(BB)~=1
        BB_W = BB(:,3);
        BB_H = BB(:,4);
        wrong_shape = BB_H < BB_W;
        len=numel(wrong_shape);
        for i=1:len
            wrong_shape(i)
            
            minx=rp(wrong_shape(i)).BoundingBox(2);
            maxx=rp(wrong_shape(i)).BoundingBox(4)+minx;
            miny=rp(wrong_shape(i)).BoundingBox(1);
            maxy=rp(wrong_shape(i)).BoundingBox(3)+miny;
            img(minx:maxx , miny:maxy)=0;
        end
        rp(wrong_shape) = [];   %get rid of them
    end
    %}
    imshow(img);
%     for i_cc=1:n_cc      
%         bb_i=vertcat(rp.BoundingBox);
%         if bb_i(3)> bb_i(4);
%            rectangle('Position',[bb_i(1),bb_i(2),bb_i(3),bb_i(4)],'EdgeColor','b','LineWidth',2 );
%            bb_i(i_cc)=[];
%         end
%     end
    maxArea=realmin;
    bigObject=zeros(1,4);
    n_cc=numel(rp);
    %indmax;
    for i_cc=1:n_cc      
        bb_i=ceil(rp(i_cc).BoundingBox);
        A=bb_i(3)*bb_i(4);
        if A > maxArea
            bigObject=bb_i;
            maxArea=A;
        end
    end
    if bigObject~=zeros(1,4)
        newimg=zeros(h,w);
        minx=bigObject(2);
        maxx=bigObject(4)+minx;
        miny=bigObject(1);
        maxy=bigObject(3)+miny;
%         for i=minx:maxx
%             for j=miny:maxy
%                newimg(i,j)=img(i,j); 
%             end
%         end
        newimg(minx:maxx , miny:maxy)= ceil(img(minx:maxx , miny:maxy));
        img=newimg;
        img=bwareaopen(img,7000);
        imshow(img);
        rectangle('Position',[bigObject(1),bigObject(2),bigObject(3),bigObject(4)],'EdgeColor','b','LineWidth',2 );
        if(movement==0)
            oldObjectPosition=bigObject;
            checkValue=1;
            movement=1;
    %       center_xOld=(rp(indexOfMax).BoundingBox(1)+rp(indexOfMax).BoundingBox(3))/2;
    %       center_yOld=(rp(indexOfMax).BoundingBox(2)+rp(indexOfMax).BoundingBox(4))/2;
    %       c_old=[center_xOld,center_yOld];
        end
    %   center_xNew=(rp(indexOfMax).BoundingBox(1)+rp(indexOfMax).BoundingBox(3))/2;
    %   center_yNew=(rp(indexOfMax).BoundingBox(2)+rp(indexOfMax).BoundingBox(4))/2;
    %   c_new=[center_xNew,center_yNew];
    %   dist = norm(c_old - c_new);
        areabetweenOld_New=rectint(oldObjectPosition,bigObject);
        if areabetweenOld_New<=oldObjectPosition*.15%areabetweenOld_New==0%newobject
            checkValue=1;
            movement=1;      
        else
            movement=movement+1;
        end
    %   diff=abs(oldObjectPosition-rp(indexOfMax).BoundingBox)

    %   pause on
    %   pause(5000);

        oldObjectPosition=bigObject;
        %movement=movement+1;
    %   center_xOld=(rp(indexOfMax).BoundingBox(1)+rp(indexOfMax).BoundingBox(3))/2;
    %   center_yOld=(rp(indexOfMax).BoundingBox(2)+rp(indexOfMax).BoundingBox(4))/2;
    %   c_old=[center_xOld,center_yOld];
    end


end