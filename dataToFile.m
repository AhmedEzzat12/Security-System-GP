function [ boolWrite,boolRead,strName,strEmail] = dataToFile( userName,userEmail,userPhone,userPassword ,mode)
%
% userName
% userPassword
% userEmail
% userPhone
%
boolWrite=0;
boolRead=0;
strName='';
strEmail='';
%fileID ='Users.txt';
header='Name,Email,Phone,Password\n';
fileID =fopen('Users.txt');
C = textscan(fileID, '%s%s%s%s', 'Delimiter', ',', 'HeaderLines', 1);
fclose(fileID);
names=C{1};
emails=C{2};
pnones=C{3};
passwords=C{4};
[r,~]=size(names);
if mode==2 %write
    %check if name repeated
    falsedata=0;
    if ismember(userName,names)==0
        names{r+1}=userName;
    else
        strName='Name already exists';
        falsedata=1;
    end
    %check if email repeated
    if ismember(userEmail,emails)==0
        emails{r+1}=userEmail;
    else
        strEmail='Email already exists';
        falsedata=1;
    end 
    if falsedata~=1
        pnones{r+1}=userPhone;    
        passwords{r+1}=userPassword;
        fileID =fopen('Users.txt','wt');
        myformat = '%s,%s,%s,%s\n';
        fprintf(fileID,header);
        r=r+1;
        for i=1:r
            fprintf(fileID,myformat,names{i},emails{i},pnones{i},passwords{i});
        end
        fclose(fileID);
        boolWrite=1;
    end
else%read
    for i=1:r
        if isequal(sprintf('%s',names{i}),sprintf('%s',userName)) && isequal(sprintf('%s',passwords{i}),sprintf('%s',userPassword))
            boolRead=1;
            break;
        end
    end
end
end

