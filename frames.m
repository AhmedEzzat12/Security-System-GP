function frames(VideoPath)
%directory='E:\CS\GP\start\GP edit gui\gp\training_videos';
%videos = dir(fullfile(directory, '*.mp4'));
%num_videos = length(videos);
%door=[0 0 0 0];
%enterence_pos=struct('floordim',[],'windowdim',[],'doordim',[]);
%for j = 1:num_videos
    %a = VideoReader(fullfile(directory, videos(j).name));
    %[~,vidname,~]=fileparts(videos(j).name);
    [path,vidname,~]=fileparts(VideoPath);
    folderName=strcat(path,'\',vidname,'_frames');
    mkdir (folderName);
    mkdir(strcat(folderName,'\reference'));
    %save frames 
    a=VideoReader(VideoPath);
    numFrames=a.NumberOfFrames;
    for img=1:numFrames
        filename=strcat(num2str(img),'.jpg');
        b=read(a,img);       
        fullFileName = fullfile(folderName, filename); % No need to worry about slashes now!
        imwrite(b, fullFileName);
    end
end