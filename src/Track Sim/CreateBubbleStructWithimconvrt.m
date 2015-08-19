

clc;
tic


%parameters and initial data
imtype = 'jpg'; %File type
filetype = strcat('*.',imtype);


%%
%Get path to main folder with image data and open folder
RootFolderPath = uigetdir;
StartFolder = pwd; %Save folder you started search from
cd(RootFolderPath); %Move to main data folder/directory
SubFolderList = dir; %Get names of all folders in root folder
RootFolder = pwd;   


%%
%Open each folder if its name does not begin with a '.'
FolderCount = 0;
FrameCount = 0;
for ii = 1:size(SubFolderList,1);
    FirstLetter = SubFolderList(ii).name(1);
    %
    %Process image files if the sub-directory name does not begin with a
    %dot
    if FirstLetter ~= '.';
        if SubFolderList(ii).isdir == 1; %Only open folders
            FolderCount = FolderCount + 1;
            disp(FolderCount)
            ImageFolderName = SubFolderList(ii).name;
            FullFolderPath = fullfile(RootFolderPath,ImageFolderName);
            cd(FullFolderPath);
            %
            %Find number of image files
            imfiles = dir(filetype);
            NumFiles = size(imfiles,1);
            %
            %Loop through images, extract Region of Interest, and save to a struct
            for jj = 1:NumFiles
                FrameCount = FrameCount + 1;
                
                %Added imconvrt function to next line instead of imread
                OpenImage = imconvrt(imfiles(jj).name);
                
                OpenImage = double(OpenImage);
                ImageFileName = strcat('im',num2str(jj));
                lib(FolderCount).track(jj).image = OpenImage;                              
            end
            %
        end
    end
end
cd(StartFolder)
%


toc
