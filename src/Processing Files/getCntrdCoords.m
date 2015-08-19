function coords = getCntrdCoords(im,th,sz)

%% Summary of function getCntrdCoords:
% Function to locate all centroids in image im.  Calls functions pkfnd and
% cntrd, written by Eric R. Dufresne, Yale University.

%% Input and output specifications:
% INPUT:
%
% - im: Image matrix containing pixel intensity values.
%
% - th: Threshold value to determine peak intensity values. Should be 
%       approximately the lowest local maximum value.
%
% - sz: Size of the search diameter when calculating the centroid of the
%       bubbles.  Should be slightly larger than the largest bubble
%       diameter and should be an odd number.
%
% OUTPUT:
%
% - coords: Nx4 Matrix containing x coordinates, y coordinates,
%           brightnesses, and radii of gyration for all centroids found in
%           image im.
%
% Written by Michael Meaden - Elmhurst College BITS Lab, 01/06/2011
%
%% Main code block:

% Modify the image matrix to make the red bubbles stand out more. Takes
% only the red values of an rgb image. If the image is not an rgb image,
% this does not affect the image matrix in any way.
im2 = im(:,:,1);

%Find local maximum intensities.
mx = pkfnd(im2,th,sz);

%Calculate coordinates of centroids of bubbles based on image, mx, and
%search diameter.  Set final parameter to 1 if you want to see the images
%used when calculating the centroid for a given bubble. Set it to 0
%otherwise.
coords = cntrd(im2,mx,sz,0);