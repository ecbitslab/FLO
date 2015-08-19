function normFrames = normalizeFrames(frames)

%% Summary of function normalizeFrames:
%  Divides all pixel intensity values in frames by the maximum pixel
%  intensity and converts to a gray scale image.  All pixel intensity
%  values in normFrames will then be between 0 and 1.

%% Input and Output specifications:
% INPUT:
%
% - frames:      Matrix containing video frames
%
% OUTPUT:
%
% - normFrames:  Matrix containing normalized frames.
%
% Written by Michael Meaden - Elmhurst College BITS Lab, 04/21/2011.

%% Main Code Block:

% Get dimensions of frames matrix and initialize normFrames matrix.
numFrames = size(frames,4);
xF = size(frames,1);
yF = size(frames,2);
normFrames = zeros(xF,yF,numFrames);

% Loop over frames, normalize images and construct normFrames matrix.
for ii = 1:1:numFrames
    grayim = double(frames(:,:,1,ii));
    normFrames(:,:,ii) = imdivide(grayim,max(max(grayim)));
end
