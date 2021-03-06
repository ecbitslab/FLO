function modTracks = delete_track(tracks,element)

%% Summary of function delete_track:
%  Function to remove specified element from the tracks structure.

%% Input and Output specifications:
% INPUT:
%
% - tracks:   Structure containing fields indices and two.  Field indices
%             contains indices of centroids that belong to a single track.
%             Field two contains a boolean value indicating whether or not
%             the track contains only two elements.  1 = two track.  0 =
%             not two track.
%
% - element:  Index of element of tracks structure to be deleted.
%
% OUTPUT:
%
% - modTracks:   Modified tracks structure.
%
% Written by Michael Meaden - Elmhurst College BITS Lab, 07/07/2011.

%% Main code block

% Initialize index counter for modTracks.
index = 1;

if size(tracks,2) == 1
    modTracks = struct('indices',{},'two',{});
end

% Loop over tracks structure and creat modTracks structure.
for ii = 1:1:size(tracks,2)
    if ii ~= element
        modTracks(index).indices = tracks(ii).indices;
        modTracks(index).two = tracks(ii).two;
        index = index+1;
    end
end