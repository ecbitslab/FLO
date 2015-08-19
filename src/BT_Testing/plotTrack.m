function [  ] = plotTrack( tracks, style )
%PLOTTRACK Plots a cell array of tracks.
%
% Inputs:
% 
% tracks - A cell array of tracks.
% 
% style - passed as the final parameter of plot. This can be things like
%         '-r', 'og', 'o', '-', ect.


for ii = 1:length(tracks)
    plot(tracks{ii}(:, 1), tracks{ii}(:, 2), style);
end


end

