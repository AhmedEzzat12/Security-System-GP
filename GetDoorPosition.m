function [door]=GetDoorPosition(VideoPath)
    [path,vidname,~]=fileparts(VideoPath);
    sceneName=strcat(path,'\',vidname,'_scene.png'); 
    scene=imread(sceneName);
    %figure,imshow(scene);
    [h ,w,~] = size(scene);
    segmentedimage = zeros(h,w);
    segmentedimage1 = zeros(h,w);
    threshold_value=255;
    for i=1:h
        for k = 1:w
            R = scene(i,k,1);
            G = scene(i,k,2);
            B = scene(i,k,3);
            if R == threshold_value && G == threshold_value&& B == threshold_value 
                segmentedimage(i,k) = 1;
            end
            if i-1>=1 && i+1<=h && k-1>=1 && k+1 <=w && R~=0 && G~=0 && B~=0
                if R==scene(i-1,k,1) && G==scene(i-1,k,2) && B==scene(i-1,k,3)&& ...
                   R==scene(i+1,k,1) && G==scene(i+1,k,2) && B==scene(i+1,k,3)&& ...
                   R==scene(i,k-1,1) && G==scene(i,k-1,2) && B==scene(i,k-1,3)&& ...
                   R==scene(i,k+1,1) && G==scene(i,k+1,2) && B==scene(i,k+1,3)
                    segmentedimage1(i,k) = 1;
                end
            end
        end
    end    
    segmentedimage1=im2bw(segmentedimage1);%figure,imshow(segmentedimage1);
    segmentedimage1=bwareaopen(segmentedimage1,10000);
    copy=segmentedimage1;%figure,imshow(copy);
    %get connected components
    connected_componentes=bwconncomp(copy); % or use bwlabel
    n_cc=connected_componentes.NumObjects;
    BB=regionprops(connected_componentes,'BoundingBox');
    maxArea=realmin;
    for i_cc = 1:n_cc
        bb_i=ceil(BB(i_cc).BoundingBox);
        if bb_i(3)*bb_i(4)> maxArea
            floor=ceil(BB(i_cc).BoundingBox);
            maxArea=bb_i(3)*bb_i(4);
        end
        %rectangle('Position',[bb_i(1) bb_i(2) bb_i(3) bb_i(4)],'EdgeColor', 'c');
    end
    segmentedimage=im2bw(segmentedimage);
    segmentedimage=bwareaopen(segmentedimage,6000);
    copy=segmentedimage;
    connected_componentes=bwconncomp(copy);
    n_cc=connected_componentes.NumObjects;
    BB=regionprops(connected_componentes,'BoundingBox');
    for i_cc = 1:n_cc
        bb_i=ceil(BB(i_cc).BoundingBox);
        area=rectint(bb_i,floor);
        if area~=0
           %arrdoor=vertcat(door,bb_i);
           door=bb_i;
           %{
           figure,imshow(scene);
           rectangle('Position', [bb_i(1) bb_i(2) bb_i(3) bb_i(4)],'EdgeColor', 'c');
           t=text(bb_i(1),bb_i(2),'door');
           t.Color=[1 0 0];
           t.FontSize = 18;
           %}
           break;
        end
    end      
end