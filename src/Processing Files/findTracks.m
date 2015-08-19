function [tcoords, tracks] = findTracks(frame,scoords,nd_min,nd_max,bd_max,sfactor,debug)

%% Summary of function assignTracks:
%  Function that assigns track numbers to each bubble centroid to indicate
%  which bright points are actually the same bubble within a single frame.

%% Input and Output specifications:
% INPUT:
%
% - frame:    Image for which the centroid coordinates will be found.
%             Assume image has already been normalized in BT_Driver.
%
% - scoords:  Sorted coordinates of particle centroids in image frame 
%             returned by function getCntrdCoords.m.  Sorted such that the
%             lowest indices are closest to the source location.
%
% - srcang:   Angle (in radians) from the x axis (which divides the frame 
%             in half horizontally) that indicates the location of the flow
%             source.  An angle of 0 radians corresponds to the source
%             being in the center of the right side of the frame, pi/2
%             corresponds to being in the center of the top of the frame,
%             etc.  The angle is used rather than a specified coordinate of
%             the source because this allows more versatility between
%             cameras, settings, and experimental setups.  It is
%             recommended that the flow source be placed such that it is
%             located in the center of one of the four sides of the frame
%             for simplicity.
%
% - srcvel:   Direction of the source velocity.  This is used as the
%             initial velocity direction of the first bubble in any given
%             track (that is, the bubble in a track that is closest to the
%             source).
%
% - nd_min:   Minimum neighbor distance user defined in BT_Driver based on
%             the histogram of nearest neighbor distances.
%
% - nd_max:   Maximum neighbor distance user defined in BT_Driver based on
%             the histogram of nearest neighbor distances.
%
% - bd_max:   Maximum bubble diameter user defined in BT_Driver based on
%             the histogram of the bubbles' radii of gyration.
%
% - sfactor:  User defined search factor.  Multiplied by bd_max to
%             increase the search area when searching for candidates.
%
% - debug:    Flag to indicate whether or not the track finding process
%             should be shown for debugging or thresholding purposes.  Can 
%             be 0, 1, or 2. 0 = no display, 1 = initial bubble in track
%             and final track displayed, 2 = entire search process
%             displayed.
%
% OUTPUT:
%
% - tcoords:  Modified scoords matrix with an additional column to keep 
%             track of whether or not a particle is still active.
%
% - tracks:   Structure containing tracks for this frame.  Each track is
%             represented by a matrix containing the index values from
%             scoords for all bubbles in the same track
%
% Written by Michael Meaden - Elmhurst College BITS Lab, 06/20/2011.

%% Preliminary processing.

% Create a 6th ones column to indicate which bubbles are still active.
activeCol = ones(size(scoords,1),1);
tcoords = cat(2,scoords,activeCol);
tracks = [];
% Create counter to keep track of number of two tracks.
num2tracks = 0;

%% Find tracks.

if debug > 0
    figure; imshow(frame); hold on;  % Plot for debugging and thresholding.
end

% Keep track of track numbers for storage purposes.
nextTrack = 1;

% Loop over centroids in frame.
for poi = 1:1:size(tcoords,1)
    % If current centroid is active, project trajectory of bubble and
    % find track.
    if tcoords(poi,6) == 1
        
        % Get x and y coordinates for point of interest.
        poix = tcoords(poi,1);
        poiy = tcoords(poi,2);
        
        % Reset found flag.
        found = 0;
        
        % Debug plot.
        if debug > 0
            clear gcf; imshow(frame); hold on;
            % Test plot to show point of interest.
            plot(tcoords(poi,1),tcoords(poi,2),'or')
            pause(0.5);
        end
        
        % Find all candidates around current point of interest between
        % nd_min and nd_max.
        candidates = find((abs(poix-tcoords(:,1))<nd_max) & (abs(poiy-tcoords(:,2))<nd_max) & tcoords(:,6)==1);
        
        % Remove poi from list of potential candidates.
        candidates = candidates(candidates~=poi);
        
        % Debug plot - displays ptrack, search area, and potential candidates
        if debug == 2
            clear gcf; imshow(frame); hold on;    
            plot(tcoords(poi,1),tcoords(poi,2),'or'); pause(0.2);
            debugAngles = 0:((2*pi)/40):2*pi;
            if nd_min ~= 0
                DBminx = poix + (nd_min)*cos(debugAngles);
                DBminy = poiy + (nd_min)*sin(debugAngles);
                plot(DBminx,DBminy,'-b');
            end
            DBmaxx = poix + (nd_max)*cos(debugAngles);
            DBmaxy = poiy + (nd_max)*sin(debugAngles);
            plot(DBmaxx,DBmaxy,'-b'); pause(0.2);
            plot(tcoords(candidates,1),tcoords(candidates,2),'og'); pause(0.2);   
        end
        
        if size(candidates,1) > 0
            % Once these "approximate candidates" are found, loop over them and
            % calculate actual distances to find actual candidates
            for ii = 1:1:size(candidates,1)
                dist = calcDistance(tcoords,poi,candidates(ii));
                if (nd_min <= dist <= nd_max)
                    % Create matrix of initial two points to be passed to
                    % project_trajectory function.
                    ptrack = [poi candidates(ii)];
                    % If the first possible track is being explored, set that
                    % as the initial probable track.
                    if found == 0
                        track = project_trajectory(frame,tcoords,ptrack,dist,bd_max,sfactor,debug);
                        % Set flag to show that a valid candidate was found and
                        % that a track will be returned.
                        found = 1;
                    else
                        % Explore all other possible tracks originating at
                        % point of interest.  Pick the one with the most
                        % bubbles (greatest support).
                        compTrack = project_trajectory(frame,tcoords,ptrack,dist,bd_max,sfactor,debug);
                        if size(track,2) < size(compTrack,2)
                            track = compTrack;
                        end
                    end
                end
            end
        end
        
        % If a track was found for the given point of interest, save the
        % indices of points in the track in the tracks structure.
        if found == 1
            
            % If the track contains only two bubbles...
            if size(track,2) == 2
                % If current track is the first two track, add index to
                % two-track index array.  If not, then ensure there are no
                % overlapping bubbles between current track and previously
                % found 2-tracks before adding current track to the tracks
                % list.
                if num2tracks > 0
                    % Set deleted flag equal to zero
                    deleted = 0;
                    % If other two tracks were already found...
                    % Find two tracks that share bubbles with the current
                    % track of interest.
                    for pInd = 1:1:size(track,2)
                        tindices = find_particle(tracks,track(pInd));
                        % If no two-tracks were found that share points,
                        % add the new track to the list and increment
                        % nextTrack.
                        if ~isempty(tindices)
                            % If a previous two-track was found that shares one
                            % bubble with the new two-track, delete both. If
                            % the two tracks are identical, don't add the
                            % new track.
                            for tind = 1:1:size(tindices,2)                                
                                if ((sum(track == tracks(tindices(tind)).indices)==1) || (sum(track == fliplr(tracks(tindices(tind)).indices))==1))
                                    tracks = delete_track(tracks,tindices(tind));
                                    num2tracks = num2tracks - 1;
                                    nextTrack = nextTrack - 1;
                                    % Set deleted flag equal to 1.
                                    deleted = 1;
                                end
                            end
                        % If no particles were found to already be in
                        % previous tracks and no tracks were already
                        % deleted, add the new track to the tracks struct.
                        elseif isempty(tindices) && pInd == size(track,2) && deleted == 0
                            tracks(nextTrack).indices = track;
                            tracks(nextTrack).two = 1;
                            num2tracks = num2tracks + 1;
                            nextTrack = nextTrack + 1;
                        end
                    end
                else
                    tracks(nextTrack).indices = track;
                    tracks(nextTrack).two = 1;
                    num2tracks = num2tracks + 1;
                    nextTrack = nextTrack + 1;
                end
            end
            
            % If the track size is greater than two, delete all two tracks
            % that share bubbles with the longer track, store track in the 
            % indices field of the tracks matrix, set two field to zero, 
            % deactivate all bubbles in the new track, and increment
            % nextTrack.
            if size(track,2) > 2
                if num2tracks > 0
                    % Delete two-tracks that share bubbles.
                    for pInd = 1:1:size(track,2)
                        % Get indices of tracks containing points in the
                        % current track of interest.
                        tindices = find_particle(tracks,track(pInd));
                        % If a track was found, delete it and decrement
                        % nextTrack by one.
                        if ~isempty(tindices)
                            for tind = 1:1:size(tindices,2)
                                tracks = delete_track(tracks,tindices(tind));
                                num2tracks = num2tracks - 1;
                                nextTrack = nextTrack - 1;
                            end
                        end
                    end
                end
                
                % Store track.
                tracks(nextTrack).indices = track;
                % Set two field to zero.
                tracks(nextTrack).two = 0;
                % Deactivate bubbles.
                tcoords(track,6)=0;
                % Increment nextTrack.
                nextTrack = nextTrack + 1;
            end
        end
        
        % Test plot to show the final track found by the tracking code.
        if (found == 1) && (debug > 0)
            clear gcf; imshow(frame); hold on;
            tx = tcoords(track,1);
            ty = tcoords(track,2);
            plot(tx,ty,'ob');
            pause(0.5);
        end
    end   
end









