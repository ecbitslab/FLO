function [ S ] = BT_Driver_Func_2( frame )
%BT_DRIVER_FUNC_2 Summary of this function goes here
%   Detailed explanation goes here

% Main driver script to assign track numbers to bubble centroids for all
% frames in a video.

% Written by Michael Meaden - Elmhurst College BITS Lab, June 15, 2011.
% Last revised on July 11, 2011.

%% Set processing flags.

% Set debugFlag to indicate whether the search process will be displayed
% during processing.  0 = will not display.  1 = will display point of
% interest and resulting track.  2 = will display entire search process.
debugFlag = 0;

%% Define relevant parameters.

% Define the threshold pixel intensity and size of particles to be used in
% the centroid finder.  These should be selected such that the threshold is
% equal to the lowest local maximum and the size is equal to the diameter
% of the largest bubble present.
th = 0.08;
sz = 5;

% Indicate source location and the direction of the velocity of the flow by
% providing angles for each.  Uses standard angle convention (counter
% clockwise from positive x-axis).
srcang = (pi)/2;

% Define minimum neighbor distance (nd_min), maximum neighbor distance (nd_max), and maximum
% bubble diameter (bd_max - use nearest neighbor distance and radius of gyration
% histogram).
nd_min = 10;
nd_max = 40;
bd_max = 6;

% Define scaling factor by which to increase the search area when searching
% for candidates in a track.
sfactor = 1;

%% Read frames.

% If vidFlag == 0, read image. If vidFlag == 1, read video. Then continue.
numFrames = 1;
frames = [frame];

% Normalize frames.
normFrames = normalizeFrames(frames);

%% Loop over frames, find centroid coordinates, and assign tracks.

for ii = 1:1:numFrames
    
    % Get next frame from frames matrix.
    frame = normFrames(:,:,ii);
    
    % Call function getCntrdCoords.
    coords = getCntrdCoords(frame,th,sz);
    
    % Sort centroids such that the lowest index corresponds to the centroid
    % closest to the source location given by srcang.
    scoords = coordSort(frame,coords,srcang);
    
    % Call assignTracks function.
    [tcoords tracks] = findTracks(frame,scoords,nd_min,nd_max,bd_max,sfactor,debugFlag);
    
    % Store video frame and coordinate data in structure s.
    S(ii).frame = frame;
    S(ii).coords = tcoords;
    S(ii).tracks = tracks;
end

end

