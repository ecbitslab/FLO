%% plume_view v1.0 Description
%Function p_v = plume_view(moviename,savename) calls function p_v.

%This function is designed to create a single image from a user defined
%video.  The resulting image is a sum of all availalble frames in the avi
%file, which contains plume data, and the resulting image shows the entire
%plume.

% Written by Alex Grabenhofer - Summer 2010.
% Modified by Mike Meaden, Elmhurst College BITS Lab - July 13, 2011
%     -- Also plots surface plot of bubble density information.

%--------------------------------------------------------------------------

%% plume_view Calling Sequence and User Variables
%Begin function

function density = plume_view(moviename,savename,th,sz)
%Calling sequence: plume_view(moviename,savename);

%moviename referes to a user defined avi file and must be entered as
%'filename.avi' including the single quotes, otherwise may return an error.
%NOTE: After modification, works for extensions other than .avi.

%savename is the userdefined variable with extension that the resulting
%normalized image will be saved as for future reference.  savename must
%include a filetype extension.  Acceptable extensions are '.bmp', '.hdf',
%'.jpg', '.jpeg', '.pbm', '.pcx', '.pgm', '.png', '.pnm', '.ppm', '.ras',
%'.tif', '.tiff', or '.xwd'.  For any information on filetype, see imwrite
%help page.
%Example of savename (including single quotes):  'sample_image.bmp'

%% Get info and Setup

m = mmreader(moviename);
%gets all information from the user defined movie

numframe = m.NumberOfFrames;
%gets the number of frames from the info

p = waitbar(0,'Processing...');
%creates a processing bar that displays the current progress of the
%function

%% Process

% Process first frame.
im_dat = read(m,1);

im_dat = normalizeFrames(im_dat);

% Get centroid coordinates for first frame.
coords(1).indices = getCntrdCoords(im_dat,th,sz);

% Initialize density matrix.
density = zeros(size(im_dat,1)+1,size(im_dat,2)+1);
addDensity = zeros(size(density));

% Find location of centroid to nearest pixel.
dcoords = ceil(coords(1).indices);

% Keep count of centroids per pixel in density matrix.
for jj = 1:1:size(dcoords,1)
    density(dcoords(jj,2),dcoords(jj,1)) = 1;
end

waitbar(1  / numframe);
%updates waitbar

for frm = 2:1:numframe
    add_dat = read(m,frm);
    add_dat = normalizeFrames(add_dat);
    %reads the next frame in the file and converts it to image data
    
    % Initialize matrix to hold density values for current frame.
    addDensity(:,:) = 0;
    
    % Get centroid coordinates for current frame.
    coords(frm).indices = getCntrdCoords(add_dat,th,sz);
    
    % Find locations of centroids in current frame to nearest pixel.
    dcoords = ceil(coords(frm).indices);
    
    % Modify density matrix.
    for ii = 1:1:size(dcoords,1)
        addDensity(dcoords(ii,2),dcoords(ii,1)) = 1;
    end
    
    density = density + addDensity;
    
    im_dat = imadd(im_dat, add_dat);
    %adds the current image data.  In order to compile the best data, the
    %variable im_dat is replaced by the sum of the previous frames.
    
    waitbar(frm / numframe);
    %updates the current progress of the function
end

density = density(1:size(density,1)-1,1:size(density,2)-1);

%% Plot showing plume and density information.
surf(density,im_dat);

%% Save and Cleanup

imwrite(im_dat,savename);
%saves the file to the user defined image with the correct format

close(p);
%closes waitbar

end
%End of function

%--------------------------------------------------------------------------
%% Acknowledgements
%%Created: v1.0 August 6, 2010    By: Alex Grabenhofer
%Notes:  Works great.  For videos should be .avi extension.  For saving,
%bmp is always a good option since there is no need to include color
%options.  Also, bmp is uncompressed format, so there is no loss of data.