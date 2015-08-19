function [  ] = plotCompare( n, o_tracks, s_tracks )
%PLOTCOMPARE Summary of this function goes here
%   Detailed explanation goes here

imshow(imread(strcat('../bubbletrk/bubbletrk', int2str(n), '.bmp'))); 
hold all; 
plotTrack(o_tracks{n}, '-'); 
plotTrack(s_tracks{n}, 'o');

end

