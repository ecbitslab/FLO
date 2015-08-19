function [ synth_tracks, observed_tracks ] = BT_Test(name, imageNum)
%BT_TEST Summary of this function goes here
%   Detailed explanation goes here

for ii = 1:imageNum
    filename = strcat(name, int2str(ii));
    S = BT_Driver_Func(strcat(filename, '.bmp'));
    synth_track = load(strcat(filename, '.mat'));
    
    synth_tracks{ii} = synthTrackToTrack(synth_track.tracks);
    observed_tracks{ii} = sToTracks(S(1));
end

end

