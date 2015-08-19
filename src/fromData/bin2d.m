function [ bins ] = bin2d( locations, bin_side, dim )
%2DBIN bins a list of positions of 2d space.
%
% Description:
%
% Breaks up an image into square bins sized bin_side x bin_side, then 
% counts how many locations are in each bin.
%
%
% Input :
%
% locations - An array of positions where, locations(5,1) gives the 5th point's x coord
%             , and locations(5,2) gives the 5th point's y coord.
%
% bin_side - bin_side gives how long one side of the bin is. Each bin is bin_side x bin_side.
%
% dim - The image dimensions
%
% Output:
%
% bins - returns a matrix with dimensions dim, such that bins(5,10) gives
%        the number of points within the bin.

% find which bin each location is in
% using ceil so ind may be used for indicies later on.
ind(:,1) = ceil(locations(:,1) / bin_side);
ind(:,2) = ceil(locations(:,2) / bin_side);

bins = zeros(ceil(dim / bin_side));

% Placing each location into its bin.
for ii = 1:size(ind,1)
    bins(ind(ii,2), ind(ii,1)) = bins(ind(ii,2), ind(ii,1)) + 1;
end

end

