function [ tracks ] = sToTracks( s )
% STOTRacks Takes a set of tracks created from TrackSim and makes it
% into a set of tracks. A track is a N x 2 matrix. track(4,1) 
% gives the 4th point in the track and the x coord, while track(4, 2)
% will give the 4th point's y coord.
%
% Inputs:
%
% s - An S structure produced from BT_Driver.
%
% Outputs:
%
% tracks - A cell array of tracks created from synth_tracks.
tracks{length(s.tracks)} = []; %Pre-allocation for speed


for ii = 1:length(s.tracks)
    % Get each points coords in the ii_th track
    track = s.tracks(ii).indices;
    x = s.coords(track, 1);
    y = s.coords(track, 2);
    
    coord = horzcat(x, y);
    
    tracks{ii} = coord;
end

end
