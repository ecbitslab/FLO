function [ data ] = BT_Stats( number_of_tracks, number_of_images )
%BT_STATS Summary of this function goes here
%   Detailed explanation goes here

% Load lib for SynthImages
load('Track Sim/lib.mat');

tmp = 0;
tap = 0;

tmt = 0;
tit = 0;
tgt = 0;
tapt = 0;
tde = 0;
tse = 0;

tp = 0;
tt = 0;

%h = waitbar(0,'Processing Frames...');

for ii = 1:number_of_images
    % Create track then use BT_Driver to find the tracks
    [image, pos] = SynthImage(number_of_tracks, lib);
    S = BT_Driver_Func_2(image);
    
    % Convert to useful format
    s_tracks = synthTrackToTrack(pos);
    o_tracks = sToTracks(S(1));
    
    % Find all the missing points and added points.
    missing_points = tracksDifference(s_tracks, o_tracks, 4);
    added_points = tracksDifference(o_tracks, s_tracks, 4);
    
    % Find how often the diffrent type of track erros occur.
    [good_tracks, incomplete_tracks, added_point_tracks, merged_tracks] = ...
        trackInfo(o_tracks, s_tracks);
    
    disjoint_events = numDisjoint(o_tracks, s_tracks);
    subset_events = number_of_subset(o_tracks, s_tracks);
    
    %% Add the data to a running total
    tmp = tmp + length(missing_points);
    tap = tap + length(added_points);

    tmt = tmt + merged_tracks;
    tit = tit + incomplete_tracks;
    tgt = tgt + good_tracks;
    tapt = tapt + added_point_tracks;
    tde = tde + disjoint_events;
    tse = tse + subset_events;
    
    tt = tt + length(s_tracks);
    
    for jj = 1:length(s_tracks);
        tp = tp + size(s_tracks{jj}, 1);
    end
    
    % Update waitbar
    %waitbar(ii/number_of_images);
end

data = [tmp, tap, tmt, tit, tgt, tapt, tde, tse, tp, tt];

%close(h);

%% Print Information
if(false)
    fprintf('Number of Points: %d\n', tp);
    fprintf('Number of Tracks: %d\n', tt);
    fprintf('Number of Missing Points: %d\n', tmp);
    fprintf('Number of Added Points: %d\n', tap);
    fprintf('Number of Merged Tracks: %d\n', tmt);
    fprintf('Number of Added Point Tracks: %d\n', tapt);
    fprintf('Number of Incomplete Tracks: %d\n', tit);
    fprintf('Number of Good Tracks: %d\n', tgt);
    fprintf('Number of Subset Events: %d\n', tse);
    fprintf('Number of Disjointed Tracks: %d\n', tde);
end
end

function [good_tracks, incomplete_tracks, added_point_tracks, merged_tracks] = trackInfo(o_tracks, s_tracks)
%TRACKINFO finds the number of occurences of several track errors.
    
    % Start everything at zero
    merged_tracks = 0;
    incomplete_tracks = 0;
    good_tracks = 0;
    added_point_tracks = 0;
    
    for jj = 1 : length(o_tracks)
        % Look at each track in o_tracks.
        track = o_tracks{jj};
        tids = pointsTrackIDs(track, s_tracks, 4);

        if(~isempty(find(tids == -1, 1))) %If a point that was not is not in s_tracks
                                          %was found this is a
                                          %added_point_track. This happens
                                          %every time that a point is
                                          %wrongly detected.
            added_point_tracks = added_point_tracks + 1;
            
        elseif(length(tids) == 1) % If there is only one track in s_tracks that track
                                  % intersects with then, the track is
                                  % either incomplete or a correct track.
            tid = tids(1);
       
            if(length(track) == length(s_tracks{tid})) % If the two tracks have the same
                                                       % number of points in them then the
                                                       % two tracks are equal and are
                                                       % correct.
                good_tracks = good_tracks + 1;
            else                                           % If they are not correct then the
                                                           % the track must be incomplete.
                incomplete_tracks = incomplete_tracks + 1;
            end
        else
            % If there are more than one tracks in s_tracks that intersect with
            % track, then two tracks have merged.
            merged_tracks = merged_tracks + 1;
        end
    end
end

function [disjoint_events] = numDisjoint(o_tracks, s_tracks)
%NUMDISJOINT finds how many occurances in which one s_track can be made up
% of a union of more than one o_track. Will still call disjoint if missing points.
    
    % Start everything at 0. 
    disjoint_events = 0;

    for jj = 1 : length(s_tracks)
        % Look at each track in s_track.
        track = s_tracks{jj};
        tids = pointsTrackIDs(track, o_tracks, 4);
   
        if(length(find(tids ~= -1)) >= 2) % Can only be disjoint if there are more
                                          % than one o_track contained in
                                          % s_track.
            
            disjoint_events = disjoint_events + 1; % Assume it is disjoint
                                                   % Remove it if it is not
                                                   % later.
            for kk = 1 : length(tids)
                tid = tids(kk);

                if(tid == -1)
                    disjoint_events = disjoint_events - 1;
                    break;
                end

                otids = pointsTrackIDs(o_tracks{tid}, s_tracks, 4);
                
                % Make sure that o_tracks{tid} does not have any
                % points not contained in s_track. If it does, then
                % this o_track{tid} is a merged_track and s_track can't
                % be disjoint. So remove the disjoint event.
                if(length(otids) ~= 1)
                    disjoint_events = disjoint_events - 1;
                    break;
                end
            end
        end
    end
end

function [subset_events] = number_of_subset(o_tracks, s_tracks)
    
    % Start everything at 0. 
    subset_events = 0;

    for jj = 1 : length(s_tracks)
        % Look at each track in s_track.
        track = s_tracks{jj};
        tids = pointsTrackIDs(track, o_tracks, 4);
   
        if(length(tids) >= 2) % Can only be disjoint if there are more
                                          % than one o_track contained in
                                          % s_track.
            
            subset_events = subset_events + 1; % Assume it is disjoint
                                                   % Remove it if it is not
                                                   % later.
            for kk = 1 : length(tids)
                tid = tids(kk);

                if(tid == -1)
                    continue;
                end

                otids = pointsTrackIDs(o_tracks{tid}, s_tracks, 4);
                
                % Make sure that o_tracks{tid} does not have any
                % points not contained in s_track. If it does, then
                % this o_track{tid} is a merged_track and s_track can't
                % be disjoint. So remove the disjoint event.
                if(length(otids) ~= 1)
                    subset_events = subset_events - 1;
                    break;
                end
            end
        end
    end
end


