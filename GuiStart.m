function varargout = GuiStart(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GuiStart_OpeningFcn, ...
    'gui_OutputFcn',  @GuiStart_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end 
function GuiStart_OpeningFcn(hObject, eventdata, handles, varargin)
%{
% Initialize a timer, which executes its callback once after one second
timer1 = timer('Period', 1, 'TasksToExecute', 1, ...
          'ExecutionMode', 'fixedRate', ...
          'StartDelay', 1);
% Set the callback function and declare GUI handle as parameter
timer1.TimerFcn = {@timer1_Callback, findobj('name','GuiStart')};
timer1.StopFcn = @timer1_StopFcn;
start(timer1);
%}

%hf=findobj('Name','login');
%close(hf);
handles.output = hObject;
guidata(hObject, handles);



%set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
imshow('logo.png','Parent',handles.axes5);
end
%{
%timer1_Callback--- Executes after each timer event of timer1.
function timer1_Callback(obj, eventdata, handle)
% Maximize the GUI window
maximize(handle);
end
%timer1_StopFcn--- Executes after timer stop event of timer1.
function timer1_StopFcn(obj, eventdata)
% Delete the timer object
delete(obj);
end
function maximize(hFig)
%MAXIMIZE: function which maximizes the figure withe the input handle
%   Through integrated Java functionality, the input figure gets maximized
%   depending on the current screen size.
if nargin < 1
    hFig = gcf;             % default: current figure
end
drawnow                     % required to avoid Java errors
jFig = get(handle(hFig), 'JavaFrame'); 
jFig.setMaximized(true);
end
%}
function varargout = GuiStart_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
end

%% START HERE

% --- Executes on button press in btnChooseVideo.
function btnChooseVideo_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*.mp4','select video','E:\CS\GP\start\GP edit gui\gp\training_videos\');
handles.output = hObject;

if(file ~= 0)
    set(handles.txtObjectDetect, 'Visible', 'off');
    %set(findobj(gcf, 'type','handles.axes3'), 'Visible','off')
    axes(handles.axes1);cla reset
    axes(handles.axes2);cla reset
    axes(handles.axes3);cla reset
    set(handles.axes3, 'Visible', 'off');
    axes(handles.axes4);cla reset
    set(handles.edit1,'string','');
    set(handles.edit2,'string','');
    handles.directoryPath=fullfile(path,file);
    Path=regexprep(handles.directoryPath,'.mp4','','ignorecase');
    Path=strcat(Path,'_frames/');
    handles.videoPath = Path;  
    [handles.door]=GetDoorPosition(handles.directoryPath);
end
guidata(hObject,handles);
end

function btnStartScribt_Callback(hObject, eventdata, handles)
cla reset
hold on
inCreaseFrameBy=6;%10;
staticWidth=0; staticHeight=0;
center_past_x =0;
center_past_y = 0;
vector_velocity = 0;
center=0;
count=0;
%f=0;
number_element_in_vector = 0;

directoryPath=handles.videoPath;
%7ramy :4.4622   3ady:5.1494
srcFiles = dir(strcat(directoryPath,'*.jpg'));
% x=strcat(directoryPath,num2str(2),'.jpg');
% Refrence_Frame=imread(x);
Refrence_Frame=getRefernceFrame(directoryPath);
[refWidth,refHeight]=size(Refrence_Frame);
relatedToRef=0.80;
k=0;
movement=0;
oldObjectPosition=zeros(1,4);
foundmissing=0;
prevarea=0;
thief='false';
for i = 1:inCreaseFrameBy:length(srcFiles)   
    if(i+inCreaseFrameBy>length(srcFiles))
        break;
    end    
    filename = strcat(directoryPath,num2str(i),'.jpg');
    I =  imread(filename); 
    filename2 = strcat(directoryPath,num2str(i+inCreaseFrameBy),'.jpg');
    I2 = imread(filename2);
    ref = getRefernceFrame(directoryPath); 
    axes(handles.axes1);cla reset
    imshow(I2,'Parent',handles.axes1);
    %%show door
    axes(handles.axes1);
    rectangle('Position', [handles.door(1,1) handles.door(1,2) handles.door(1,3) handles.door(1,4)],'EdgeColor', 'c','Parent',handles.axes1);
    t=text(handles.door(1,1),handles.door(1,2),'door');
    t.Color=[1 0 0];
    t.FontSize = 10;   
    %subplot(1,3,1),imshow(I2);
    if isequal(I,I2),nomotion=1;else nomotion=0;end
    [testImage,Refrence_Frame,k]=Motion_Detection(I,I2,Refrence_Frame,k,handles.directoryPath);
    testImage=bwareaopen(testImage,5000);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    object=object_detection( I2, ref);
    object=bwareaopen(object,1300);
    [labeledImage,] = bwlabel(object);
    %axes(handles.axes3);
    rp = regionprops(labeledImage,'BoundingBox' ,'area');  
    if foundmissing~=1
    axes(handles.axes3);cla reset
    set(handles.axes3, 'Visible', 'off');
    end
    imshow(object,'Parent',handles.axes3);
    if foundmissing~=1
    axes(handles.axes3);cla reset
    set(handles.axes3, 'Visible', 'off');
    end
    %subplot(1,3,1),imshow(object);
    a = [rp.Area];
    [~ ,indexOfMax]=max(a(:));
    a(indexOfMax)=0;  
    [~ ,indexOfMax]=max(a(:));
    [v,v1] = size(a);
    %axes(handles.axes3);
    if (v~=0 && a(indexOfMax) >=1300)
        if foundmissing~=1
           axes(handles.axes3);cla reset
           set(handles.axes3, 'Visible', 'off');
        end
        rectangle('Position',[rp(indexOfMax).BoundingBox(1),rp(indexOfMax).BoundingBox(2),rp(indexOfMax).BoundingBox(3),rp(indexOfMax).BoundingBox(4)], 'EdgeColor','r','LineWidth',2 ,'Parent',handles.axes3);
        if foundmissing~=1
           axes(handles.axes3);cla reset
           set(handles.axes3, 'Visible', 'off');
        end  
    end
    try
        xxx= minus(rp(indexOfMax).BoundingBox(3), center);
    catch
        xxx=100000;
    end
    %%count 
    if (100 >= abs(xxx))
        count=count+1;
    else
        count = 0;
    end
    if(count>7)
         minxx = rp(indexOfMax).BoundingBox(1);
         maxxx = rp(indexOfMax).BoundingBox(3);
         minyy = rp(indexOfMax).BoundingBox(2);
         maxyy = rp(indexOfMax).BoundingBox(4);
         
         object_from_ref = imcrop(ref,[minxx minyy maxxx maxyy]);
         object_from_frame = imcrop(I2,[minxx minyy maxxx maxyy]);
         flag=0;
         result_of_sub = imsubtract(object_from_ref,object_from_frame);
         num_of_black=0;
         [h,w]=size(result_of_sub);
         for index=1:h
             for jindex=1:w
               if (result_of_sub(index,jindex)==0)
                   num_of_black=num_of_black+1;
               end
             end
         end
         if(num_of_black>(h*w*0.5))
         figure,imshow(object_from_ref); 
		 title('Missing Object Detected');
         set(handles.txtObjectDetect, 'Visible', 'on');
         set(handles.axes3, 'Visible', 'on');
         foundmissing=1;
         end
         
     end
    try
        center =[rp(indexOfMax).BoundingBox(3)];
    catch
        center=0;
    end
    axes(handles.axes2);cla reset
    imshow(testImage,'Parent',handles.axes2);
    %if nomotion~=1
    [checkValue,oldObjectPosition,movement,testImage]= newObject(testImage,movement,oldObjectPosition);
    %end
        
    rectangle('Position',[oldObjectPosition(1),oldObjectPosition(2),oldObjectPosition(3),oldObjectPosition(4)],'Parent',handles.axes4, 'EdgeColor','y','LineWidth',2 );
    
%     rectarea=oldObjectPosition(3)*oldObjectPosition(4);
%             
%             %object get closer
%             if(prevarea>rectarea&&prevarea~=0)
%                 steptoface=imcrop(I,oldObjectPosition);
%                 [r_steptoface,c_steptoface]=size(steptoface);
%                 r_steptoface=ceil(r_steptoface*.30);
%                 c_steptoface=ceil(c_steptoface*.15);
%                 steptoface=imcrop(I,[oldObjectPosition(1),oldObjectPosition(2),r_steptoface,c_steptoface]);
%                 figure,imshow(steptoface);
%                 %{
%                 steptoface_copy=steptoface;
%                 [r_steptoface,c_steptoface]=size(steptoface_copy);
%                 steptoface_BI=zeros(r_steptoface,c_steptoface);
%                 numofpixels=0;
%                 for ii=1:r_steptoface
%                     for jj = 1:c_steptoface
%                         R = steptoface_copy(ii,jj,1);
%                         G = steptoface_copy(ii,jj,2);
%                         B = steptoface_copy(ii,jj,3);
%                         if R > 95 && G > 40&& B > 20     
%                             v = [R,G,B];
%                             if((max(v) - min(v)) > 15)
%                                 if(abs(R-G) > 15 && R > G && R > B)
%                                     steptoface_BI(ii,jj) = 1;
%                                     numofpixels=numofpixels+1;
%                                 end
%                             end
%                         end
%                     end
%                 end
%                 numofpixels=numofpixels/(r_steptoface*c_steptoface)*100
%                 figure,imshow(steptoface_BI);
%                 pause on 
%                 pause(10000);
%                 %}
%             end
%             
%             
%             prevarea=rectarea;
            
            
    
    
    % connecting close white areas
    BW = testImage;
    [labeledImage, ] = bwlabel(BW);
    rp = regionprops(labeledImage,'BoundingBox' ,'area','MajorAxisLength','MinorAxisLength');
    %final = ismember(labeledImage, indexOfMax);
    %axes(handles.axes2);
    axes(handles.axes4);cla reset
    imshow(I2,'Parent',handles.axes4);
    try
        % for k=1:length(rp)
        %     currentBB=rp(k).BoundingBox;
        %     rectangle('Position',[currentBB(1),currentBB(2),currentBB(3),currentBB(4)], 'EdgeColor','r','LineWidth',2 )
        % end
        a = rp.Area;
        [~ ,indexOfMax]=max(a(:));
    catch
    end
    try
        if(rp(indexOfMax).BoundingBox(3)<=staticHeight)
            staticWidth=rp(indexOfMax).BoundingBox(3);
        else
            staticWidth =staticHeight/2;
        end
        if(rp(indexOfMax).BoundingBox(4)>staticHeight)
            staticHeight=rp(indexOfMax).BoundingBox(4);
        end
        %rectangle('Position',[x,y,w,h])
        if rp(indexOfMax).BoundingBox(3)<refWidth*relatedToRef % && rp(indexOfMax).BoundingBox(4)<refHeight*relatedToRef 
            rectangle('Position',[rp(indexOfMax).BoundingBox(1),rp(indexOfMax).BoundingBox(2),rp(indexOfMax).BoundingBox(3),rp(indexOfMax).BoundingBox(4)],'Parent',handles.axes4, 'EdgeColor','y','LineWidth',2 );
            if strcmp(thief,'true')
                axes(handles.axes4);
                t=text(rp(indexOfMax).BoundingBox(1),rp(indexOfMax).BoundingBox(2),'Thief');
                t.Color=[1 0 0];
                t.FontSize = 11;
            end
            area=rectint(handles.door,ceil(rp(indexOfMax).BoundingBox));
            if   checkValue==1 && area==0
                 axes(handles.axes4);
                 t=text(rp(indexOfMax).BoundingBox(1),rp(indexOfMax).BoundingBox(2),'Suspected');
                 t.Color=[1 0 0];
                 t.FontSize = 11;   
                 t=text(rp(indexOfMax).BoundingBox(1),rp(indexOfMax).BoundingBox(2)+70,'abnormal');
                 t.Color=[1 0 0];
                 t.FontSize = 11;   
                 t=text(rp(indexOfMax).BoundingBox(1),rp(indexOfMax).BoundingBox(2)+(70*2),'entrance');
                 t.Color=[1 0 0];
                 t.FontSize = 11;         
                 
                 %%Ahmed e3ml classify hena 3shan 7d ma da5alsh mn el door
                 imageToBeClassified=imcrop(I2,[rp(indexOfMax).BoundingBox(1),rp(indexOfMax).BoundingBox(2),rp(indexOfMax).BoundingBox(3),rp(indexOfMax).BoundingBox(4)]);
                 result=classifyUsingSVM(imageToBeClassified,handles.svmStruct)
                 %rp(indexOfMax).MajorAxisLength
                 %rp(indexOfMax).MinorAxisLength
                 if rp(indexOfMax).MajorAxisLength> (2*rp(indexOfMax).MinorAxisLength ) 
                     thief='true';
                 else
                     thief='false';
                 end
                 % restult ----> 1 = human and 0 otherwise
            end
            minx = rp(indexOfMax).BoundingBox(1);
            maxx = staticWidth + minx;
            miny = rp(indexOfMax).BoundingBox(2);
            maxy = staticHeight + miny;
            centerx = (minx + maxx)/2;
            centery = (miny + maxy)/2;
            if center_past_x ~= 0 || center_past_y ~= 0
                dif_center_x = centerx - center_past_x;
                dif_center_y = centery - center_past_y;

                dif_center_x = dif_center_x^2;
                dif_center_y = dif_center_y^2;

                sum_diff = dif_center_x + dif_center_y;
                dis = sqrt(sum_diff);
                velocity = dis / inCreaseFrameBy; %% bosy hena el doctor 2al keda el sor3a htb2a per frame msh per second f5loha keda 2shta
                %if velocity ~= 0
                if(velocity>20)
                    velocity=1;
                end
                set(handles.edit1,'string',num2str(velocity));
                vector_velocity = [vector_velocity; velocity];
                number_element_in_vector = number_element_in_vector + 1;
                %end
            end
            center_past_x = centerx;
            center_past_y = centery;
        end
    catch
    end   
    drawnow
end
%figure,imshow(closeBW);6
%k
sum_velocity = 0;
for i = 1:number_element_in_vector
    sum_velocity = sum_velocity + vector_velocity (i);
end
average_velocity = sum_velocity / number_element_in_vector;
set(handles.edit2,'string',num2str(average_velocity));
guidata(hObject,handles);
end%end function

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
handles.axes1;
frames(handles.directoryPath);
%{
cla reset
rectangle('Position', [door(1) door(2) door(3) door(4)],'EdgeColor', 'c','Parent',handles.axes1);
t=text(bb_i(1),bb_i(2),'door');
t.Color=[1 0 0];
t.FontSize = 18;
%}
guidata(hObject,handles);
end%end function

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
end%end function


% --- Executes on button press in train.
function train_Callback(hObject, eventdata, handles)
svmStruct=trainModel();
accuracy=test_ml(svmStruct);
set(handles.edit_accuracy,'string',num2str(accuracy));
set(handles.edit_accuracy, 'enable', 'off');
handles.svmStruct=svmStruct;
guidata(hObject,handles);
end
