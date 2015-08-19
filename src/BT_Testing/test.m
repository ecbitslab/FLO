for track_num = 1 : 20
    
fprintf('Bubble Track Set #%d\n\n', track_num);

missing_points = tracksDifference(s_tracks{track_num}, o_tracks{track_num}, 4);
added_points = tracksDifference(o_tracks{track_num}, s_tracks{track_num}, 4);

fprintf('Number of Missing Points: %d\n', size(missing_points, 1));
fprintf('Number of Added Points: %d\n', size(added_points, 1));


merged_tracks = 0;
incomplete_tracks = 0;
good_tracks = 0;
added_point_tracks = 0;

for ii = 1 : length(o_tracks{track_num})
    track = o_tracks{track_num}{ii};
    tids = pointsTrackIDs(track, s_tracks{track_num}, 4);
    
    if(length(find(tids == -1)) ~= 0)
        added_point_tracks = added_point_tracks + 1;
    elseif(length(tids) == 1)
       tid = tids(1);
       
       if(length(track) == length(s_tracks{track_num}{tid}))
           good_tracks = good_tracks + 1;
       else
           incomplete_tracks = incomplete_tracks + 1;
       end
    else
        merged_tracks = merged_tracks + 1;
    end
        
end

fprintf('Number of Merged Tracks: %d\n', merged_tracks);
fprintf('Number of Added Point Tracks: %d\n', added_point_tracks);
fprintf('Number of Incomplete Tracks: %d\n', incomplete_tracks);
fprintf('Number of Good Tracks: %d\n', good_tracks);

disjoint_events = 0;

for ii = 1 : length(s_tracks{track_num})
    track = s_tracks{track_num}{ii};
    tids = pointsTrackIDs(track, o_tracks{track_num}, 4);
   
    if(length(find(tids ~= -1)) >= 2)
        disjoint_events = disjoint_events + 1;
        for jj = 1 : length(tids)
            tid = tids(jj);
            
            if(tid == -1)
                continue;
            end
            
            otids = pointsTrackIDs(o_tracks{track_num}{tid}, s_tracks{track_num}, 4);
            if(length(otids) ~= 1)
                disjoint_events = disjoint_events - 1;
                break;
            end
        end
    end
end

fprintf('Number of Disjointed Tracks: %d\n', disjoint_events);
fprintf('----------------\n\n');
end