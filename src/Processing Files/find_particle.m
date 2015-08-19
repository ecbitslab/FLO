function trackIndices = find_particle(tracks,pIndex)

%% Summary of function find_particle:
%  Function to get indices of tracks in structure tracks that contain the
%  particle pIndex.

%% Input and Output specifications:
% INPUT:
%
% - tracks:   Structure containing fields indices and two.  Field indices
%             contains indices of centroids that belong to a single track.
%             Field two contains a boolean value indicating whether or not
%             the track contains only two elements.  1 = two track.  0 =
%             not two track.
%
% - pIndex:   Index of particle being searched for.
%
% OUTPUT:
% - indices:  Indices of tracks containing particle pIndex.
%
% Written by Michael Meaden - Elmhurst College BITS Lab, 07/07/2011.

%% Main code block.

% Initialize trackIndices
trackIndices = [];

% Loop over tracks in structure tracks and search for pIndex.  If found in
% a track, indicate track index in trackIndices matrix.
for ii = 1:1:size(tracks,2)
    ind = find(tracks(ii).indices == pIndex);
    if ~isempty(ind)
        trackIndices = [trackIndices ii];
    end
end