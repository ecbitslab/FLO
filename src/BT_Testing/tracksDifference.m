function [ missing_tids ] = tracksDifference( tracks1, tracks2, max_distance )
%TRACKSDIFFERENCE returns the points in tracks1 that do not appear in tracks2.
%
% Input:
%
% tracks1 - A cell array of tracks.
%
% tracks2 - A cell array of tracks.
%
% max_distance - The maxium distance between two points to be considered
%                the same.
%
% Output:
%
% missing_tids - An array of [track_id, point_id]'s of points that appear
%                in tracks1 but not tracks2.

missing_tids = [];

for ii = 1:length(tracks1)
    track = tracks1{ii};
    for jj = 1:size(track,1)
        [t_i, p_i] = findTrackId(track(jj, :), tracks2, max_distance);
        
        % If the point was not found in tracks2 to add it
        % to missing_tids.
        if(t_i == -1 || p_i == -1)
            missing_tids = [[ii, jj]; missing_tids];
        end
    end
end

end

