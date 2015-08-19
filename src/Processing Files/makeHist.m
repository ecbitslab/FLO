% Script to create histograms of inter-particle distance, radius of
% gyration, and eccentricity (optional).

% Written by Mike Meaden, Elmhurst College BITS Lab - 6/1/2011

tic;

%% Define relevant parameters.

% Define the threshold pixel intensity and size of particles to be used in
% the centroid finder.  These should be selected such that the threshold is
% equal to the lowest local maximum and the size is equal to the diameter
% of the largest bubble present.
th = 0.5;
sz = 8;

% Specify search radius when searching nearest neighbor pairs.
rad = 60;

%% Read in video and get frames.
video = mmreader('Run_2.MOV');
numFrames = video.NumberOfFrames;
%numFrames = 10;
frames = read(video,[1,numFrames]);
normFrames = normalizeFrames(frames);  %frames2 = frames(:,:,1,:);


% Initialize waitbar.
h = waitbar(0,'Finding centroid coordinates...');

for ii = 1:1:numFrames
    % Get next frame from frames matrix.
    frame = normFrames(:,:,ii);
    
    % Call function getCntrdCoords.
    scoords = getCntrdCoords(frame,th,sz);
    
    % Store video frame and coordinate data in structure s.
    s(ii).frame = frame;
    s(ii).coords = scoords;
    
    % Update waitbar.
    waitbar(ii/numFrames);
end

close(h);

% Get histogram data.
[DH RGH EH] = getHist(s, numFrames, rad);

toc;
