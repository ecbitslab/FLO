function [ tracks ] = synthTrackToTrack( synth_tracks )
%SYNTHTRACKTOTRACK Takes a set of tracks created from TrackSim and makes it
% into a set of tracks. A track is a N x 2 matrix. track(4,1) 
% gives the 4th point in the track and the x coord, while track(4, 2)
% will give the 4th point's y coord.
% 
% Inputs:
%
% synth_tracks - A set of tracks from TrackSim that will be converted to
%                a cell array of tracks.
%
%
% Outputs:
%
% tracks - A cell array of tracks created from synth_tracks.

tracks{length(synth_tracks)} = [];  % Pre-allocation for speed

for ii = 1 : length(synth_tracks)
    x = synth_tracks(ii).c;
    y = synth_tracks(ii).r;
    
    tracks{ii} = horzcat(x,y);
end


end

