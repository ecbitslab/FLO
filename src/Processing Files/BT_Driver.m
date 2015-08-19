% Main driver script to assign track numbers to bubble centroids for all
% frames in a video.

% Written by Michael Meaden - Elmhurst College BITS Lab, June 15, 2011.
% Last revised on July 11, 2011.

%% Set processing flags.

tic;

% Set vidFlag to indicate whether a single frame or a video is being
% processed. 1 = video, 0 = single frame.
vidFlag = 1;

% Set debugFlag to indicate whether the search process will be displayed
% during processing.  0 = will not display.  1 = will display point of
% interest and resulting track.  2 = will display entire search process.
debugFlag = 0;

%% Define relevant parameters.

% Specify start frame and number of frames.  If numFrames = 0, processes
% entire video.
start_frame = 0;
numFrames = 0;

% Define the threshold pixel intensity and size of particles to be used in
% the centroid finder.  These should be selected such that the threshold is
% equal to the lowest local maximum and the size is equal to the diameter
% of the largest bubble present.
th = 0.1;
sz = 9;

% Indicate source location and the direction of the velocity of the flow by
% providing angles for each.  Uses standard angle convention (counter
% clockwise from positive x-axis).
srcang = (pi)/2;

% Define minimum neighbor distance (nd_min), maximum neighbor distance (nd_max), and maximum
% bubble diameter (bd_max - use nearest neighbor distance and radius of gyration
% histogram).
nd_min = 5;
nd_max = 25;
bd_max = 9;

% Define scaling factor by which to increase the search area when searching
% for candidaStes in a track.
sfactor = 1;

%% Read frames.

% If vidFlag == 0, read image. If vidFlag == 1, read video. Then continue.
if vidFlag == 0
    numFrames = 1;
    frames = imread('bubbleck.bmp');
else
    video = VideoReader('Data\June\bookinfront_2015-06-03-145807-0000.avi');
    if numFrames == 0
        start_frame = 1;
        numFrames = get(video,'NumberOfFrames');
    end
    frames = read(video,[start_frame,start_frame + numFrames-1]);
end

% Normalize frames.
normFrames = normalizeFrames(frames);

toc;

%% Loop over frames, find centroid coordinates, and assign tracks.

% Initialize waitbar.
h = waitbar(0,'Processing Frames...');

for ii = 1:1:numFrames
    
    tic
    
    % Get next frame from frames matrix.
    frame = normFrames(:,:,ii);
    
    % Call function getCntrdCoords.
    coords = getCntrdCoords(frame,th,sz);
    if size(coords,1) < 4
        coords
        imshow(frame);
        continue
    end
    % Sort centroids such that the lowest index corresponds to the centroid
    % closest to the source location given by srcang.
    scoords = coordSort(frame,coords,srcang);
    
    % Call assignTracks function.
    [tcoords tracks] = findTracks(frame,scoords,nd_min,nd_max,bd_max,sfactor,debugFlag);
    
    % Store video frame and coordinate data in structure s.
    S(ii).frame = frame;
    S(ii).coords = tcoords;
    S(ii).tracks = tracks;
    
    % Update waitbar.
    waitbar(ii/numFrames);
    toc
end

close(h);