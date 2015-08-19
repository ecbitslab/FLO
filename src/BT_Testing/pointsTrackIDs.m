function [ track_ids ] = pointsTrackIDs( points, tracks, max_distance )
%POINTTRACKIDS finds the index of the points in tracks.
%   
% Input:
%
% points - An array of points.
%
% tracks - A cell array of tracks.
%
% max_distance - The maxium distance between two points to be considered
%                the same.
% Output:
%
% track_ids - returns an array of indecies. This is such that
%             tracks{track_id} contains a point in points. If a tid is -1
%             there was at least one point that was not in tracks.

track_ids = [];

for ii = 1 : size(points, 1)    
    point = points(ii, :);
    
    [ti, u] = findTrackId(point, tracks, max_distance);
    
    % If the ti is not in track_ids, append it to track_ids.
    if(~any(track_ids == ti))
        track_ids = [track_ids, ti];
    end
end

