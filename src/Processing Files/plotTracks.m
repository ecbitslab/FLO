function plotTracks(s,frm,ptsFlag)

%% Summary of function plotTracks.m:
% Function to plot all tracks within a specified frame within the struct s.
% s is returned by running the script BT_Driver.m

%% Input and output specifications:
% INPUT:
%
% - s:   (Number of frames)x1 Structure with fields frame, coords, and
%        tracks.  Used to obtain indices of points that are in the same
%        track (from tracks field).
%
% - frm: Index of s for which the frame and tracks will be plotted.
%
% - ptsFlag:  Boolean value to indicate whether the user wants all
%             centroids to be plotted as well.  1 = Plot red lines through
%             tracks and green circles on all centroids.  0 = Only plot
%             red lines through tracks.
%
% OUTPUT:
%
% There are no output variables.  The function will display a figure
% displaying the plot of the specified frame and all tracks in that frame.
%
% Written by Michael Meaden, Elmhurst College BITS Lab - March 31, 2011.
% Revised for Ver2 on June 27, 2011.

%% Main Code Block:

% Get the frame of interest that is to be plotted.
F = s(frm).coords;

% Initialize figure.
figure; imshow(s(frm).frame); hold on;

% Loop over all tracks in the current frame.
for ii = 1:1:size(s(frm).tracks,2) 
    
    track = s(frm).tracks(ii).indices;
    xcoords = s(frm).coords(track,1);
    ycoords = s(frm).coords(track,2);
    
    % If ptsFlag is set, plot points in tracks as green circles.
    if ptsFlag == 1
        plot(xcoords,ycoords,'og');
    end
    
    % If the current track is 2 points or longer, plot a best fit
    % polynomial curve through the points in the track.
    if (size(track,2) >= 2)
        %p = polyfit(xcoords,ycoords,2);
        %f = polyval(p,xcoords);
        %plot(xcoords,f,'-r');
        plot(xcoords,ycoords,'-r');
    end
end