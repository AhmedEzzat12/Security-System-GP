
#pic1
areaofbbox=(maxx-minx)*(maxy-miny);
vectorofarea(vindex)=areaofbbox;
vindex=vindex+inCreaseFrameBy;     %inCreaseFrameBy=10;
vectorof_bb_dim(i)=[minx maxx miny maxy];
--------------------------------------------------------------------
#pic 2& 3
============================================
getfolderpath='C:\Users\manarty\Downloads\gp\frames';
%wfolderpath='C:\Users\manarty\Downloads\gp\try';
for i = 1:inCreaseFrameBy:length(srcFiles)
    if((indx_ofmax-i)<=67)
        baseFileName = 'i.jpg';
        fulfilname = fullfile(getfolderpath, baseFileName);
        originalimg=imread(fulfilname);
        cimg=imcrop(originalimg,vectorof_bb_dim(i));
        si=skin(cimg)     
%        if(si==1)   ahmaaaaaaaaaaaaaaaaaad 4of da 
%            call missing object function 
%        else 
%            the person is a thef
%        end
       %imshow(si,'Parent',handles.axes7);
    end
end

