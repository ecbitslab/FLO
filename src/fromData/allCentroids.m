function [ centroids ] = allCentroids( s_array )
%ALLCENTRIODS Takes the "S" variable produce by BT_Driver and gives the
%location of all centriods

% Description - Takes the S variable produced by BT_Driver and returns
%               a simpler list of centriods for the entire video.
%
% Inputs :
%
% s_array - The S variable produced by BT_Driver
%
% Output :
%
% centriods - An array that stores the position of all centriods in the video, such that
%             centriods(5,1) is the 5th centriod's x coord, and
%             centriods(5,2) is the 5th centriod's y coord.
%

centroids = []; 

% concat each frames centriods into one big array
for ii = 1:size(s_array,2)
    s = s_array(ii);
    coord = s.coords(:, 1:2);
    
    centroids = vertcat(centroids, coord);
end

end

