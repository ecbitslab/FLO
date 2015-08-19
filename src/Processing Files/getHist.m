function [DH RGH EH] = getHist(s,numFrames,rad)

%% Summary of function distHist.m:
% Returns a matrix containing histogram data for inter-particle distances
% for a given structure containing centroid coordinate data (coords).  Only
% particles within a specified search radius will be considered.

%% Input and output specifications:
% INPUT:
% - s:    Structure containing centroid coordinate data for every frame
%         in a given video.
%
% - numFrames:  Number of frames in the video file.
%
% - rad:  Specified search radius in which to find nearest neighbor
%         pairs of points.
%
% Output:
% - EH:  Matrix containing histogram data for inter-particle distances for
%        the video.
%
% Written by Mike Meaden, Elmhurst College BITS Lab - 6/1/2011

%% Main Code Block

DH = [];
RGH = [];
EH = [];

% Initialize waitbar.
h = waitbar(0,'Gathering histogram data...');

% Loop over frames.
for ii = 1:1:numFrames
    
    % The following section is for a histogram of eccentricity values.%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     BWim = im2bw(s(ii).frame,0.3);
%     rp  = regionprops(BWim, 'Eccentricity');
%     
%     for jj = 1:1:size(rp,1)
%         EH = [EH rp(jj).Eccentricity];
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Loop over all points - shift point of interest.
    for poi = 1:1:size(s(ii).coords,1)
        % Get radius of gyration data
        radGyr = s(ii).coords(poi,4);
        RGH = [RGH radGyr];
        
        % Get x and y coordinates for point of interest.
        poix = s(ii).coords(poi,1);
        poiy = s(ii).coords(poi,2);
        
        % Loop over remaining points to calculate inter-particle distances.
        for kk = (poi+1):1:size(s(ii).coords,1)
            x2 = s(ii).coords(kk,1);
            y2 = s(ii).coords(kk,2);
            interDist = sqrt((poix-x2)^2 + (poiy-y2)^2);
            if interDist <= rad
                DH = [DH interDist];
            end
        end
    end
    
    % Update waitbar.
    waitbar(ii/numFrames);
end

close(h);