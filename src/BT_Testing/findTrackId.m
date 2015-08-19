function [ track_id, point_id ] = findTrackId( point, tracks, max_distance )
%FINDTRACKID
% Description:
% This function will deterimine the numbers track_id and point_id such
% that track{track_id}(point_id, :) == point, where == means within a
% threshold.
%
% Inputs:
%
% point - the point you wish to find the track_id and point_id for in
%         tracks.
%
% tracks - A cell array of tracks.
%
% max_distance - the maximum distance in which two points must be to be
%                considered equal.
%
% Output
% track_id - the index that gives the track the point is in. So
%            track{track_id} contains point. If the point can't be found -1
%            is returned.
%
% point_id - the index in the track is the point. So
%            track{track_id}(point_id, :) == point. If the point can't be
%            found -1 is returned.

x = point(1);
y = point(2);

track_id = -1;
point_id = -1;

% Used to make sure that the point is close enough.
min_d2 = max_distance * max_distance;

for ii = 1:length(tracks)
    track = tracks{ii}; 
    
    for jj = 1:size(track, 1)
        % Calculate the distance between the point tracks{ii}(jj, :) and
        %  [x,y]
        dx = x - track(jj, 1);
        dy = y - track(jj, 2);
        
        distance2 = dx * dx + dy * dy;
        
        if(distance2 < min_d2) % check that the point is close enough
            track_id = ii;
            point_id = jj;
            return;
        end
    end
end


end

