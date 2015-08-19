function [ tdata ] = BT_StatMean( trackNum, frameNum, runNum )
%BT_STATMEAN Summary of this function goes here
%   Detailed explanation goes here

tdata = zeros(runNum, 10);

h = waitbar(0,'Processing Frames...');

for ii = 1:runNum
    % [missing points, added points, merged tracks, incomplete tracks, 
    %  good tracks, added point tracks, disjoint events, subset events, 
    %  points, tracks]
    data = BT_Stats(trackNum, frameNum);
    tdata(ii, :) = data(:);
    waitbar(ii/runNum);
    
    save('data.mat', 'tdata');
end

close(h);

end

