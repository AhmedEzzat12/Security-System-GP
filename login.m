function varargout = login(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @login_OpeningFcn, ...
                   'gui_OutputFcn',  @login_OutputFcn, ...
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
% End initialization code - DO NOT EDIT
end
% --- Executes just before login is made visible.
function login_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for login
refresh
imshow('logo.png','Parent',handles.axes1);
handles.output = hObject;
guidata(hObject, handles);
% UIWAIT makes login wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end
% --- Outputs from this function are returned to the command line.
function varargout = login_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end


% --- Executes on button press in btnSignIn.
function btnSignIn_Callback(hObject, eventdata, handles)
%userName=get(handles.txtName,'String');
%userPassword=get(handles.txtPassword,'String');
[userName,userPassword]=logindlg;
userEmail='';userPhone='';
[ ~,boolRead,~,~] = dataToFile( userName,userEmail,userPhone,userPassword ,1);
handles.output = hObject;
guidata(hObject, handles);
if boolRead==1    
    closereq;
    GuiStart;
    %GuiStart(handles.btnSignIn);
    %guidata(hObject, handles);
else
    msgbox('You did not login before ','invalid user data');
end
end

% --- Executes on button press in btnSignUp.
function btnSignUp_Callback(hObject, eventdata, handles)
set(handles.txtErrorName, 'Visible', 'off');
set(handles.txtErrorEmail, 'Visible', 'off');

userName=get(handles.txtName,'String');
userPassword=get(handles.txtPassword,'String');
userEmail=get(handles.txtEmail,'String');
userPhone=get(handles.txtPhone,'String');
[ boolWrite,~,strName,strEmail] = dataToFile( userName,userEmail,userPhone,userPassword ,2);

if isequal(sprintf('%s', strName),'')==0
set(handles.txtErrorName, 'Visible', 'on');
set(handles.txtErrorName,'String',sprintf('%s.', strName));
end
if isequal(sprintf('%s', strEmail),'')==0
set(handles.txtErrorEmail, 'Visible', 'on');
set(handles.txtErrorEmail,'String',sprintf('%s.', strEmail));
end
if boolWrite==1
    btnSignIn_Callback(hObject, eventdata, handles);
%GuiStart;       
%hide(login);    
end
handles.output = hObject;
guidata(hObject, handles);


end

% --- Executes on button press in rdbtn_newUser.
function rdbtn_newUser_Callback(hObject, eventdata, handles)
checkValue=get(handles.rdbtn_newUser,'Value');
if checkValue==1
    set(handles.text2, 'enable', 'on');
    set(handles.txtEmail, 'enable', 'on');
    set(handles.text3, 'enable', 'on');
    set(handles.txtPhone, 'enable', 'on');
    set(handles.text5, 'enable', 'on');
    set(handles.txtName, 'enable', 'on');
    set(handles.text4, 'enable', 'on');
    set(handles.txtPassword, 'enable', 'on');
    set(handles.btnSignUp, 'enable', 'on');
else
    set(handles.text2, 'enable', 'off');
    set(handles.txtEmail, 'enable', 'off');
    set(handles.text3, 'enable', 'off');
    set(handles.txtPhone, 'enable', 'off');
    set(handles.text5, 'enable', 'off');
    set(handles.txtName, 'enable', 'off');
    set(handles.text4, 'enable', 'off');
    set(handles.txtPassword, 'enable', 'off');
    set(handles.btnSignUp, 'enable', 'off');
end
handles.output = hObject;
guidata(hObject, handles);
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
end%end function
