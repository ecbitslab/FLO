function scoords = coordSort(im,coords,srcang)

%% Summary of function calcAngle:
%  Function that sorts the points specified in matrix coords based on how
%  close they are to the location on the edge of the frame specified by
%  srcang, the angle to the flow source position.  The function
%  automatically calculates the coordinates of the source, determines the
%  distance between the source and each centroid coordinate, and stores
%  this distance in an additional column in the coords matrix.  An ordinary
%  MATLAB row sort is then used to reorder the rows of the coords matrix
%  placing the centroids closest to the source in the first index
%  positions.

%% Input and Output specifications:
% INPUT:
%
% - im:       Image for which the centroid coordinates were found.  Needed
%             to determine appropriate coordinates for the source location.
%             Assume that the image is not rgb and only has two dimensions.
%
% - coords:   Matrix of centroid coordinates returned by getCntrdCoords.
%
% - srcang:   Angle (in radians) from the x axis (which divides the frame 
%             in half horizontally) that indicates the location of the flow
%             source.  The source is assumed to be on the edge of the frame
%             when this angle is used to calculate the coordinates.  An
%             angle of 0 radians corresponds to the source being in the
%             center of the right side of the frame, pi/2 corresponds to
%             being in the center of the top of the frame, etc.  The angle
%             is used rather than a specified coordinate of the source
%             because this allows more versatility between cameras,
%             settings, and experimental setups.  It is recommended that
%             the flow source be placed such that it is located in the
%             center of one of the four sides of the frame for simplicity.
%
% OUTPUT:
%
% - scoords:  Matrix of same coordinate values given in the input matrix
%             coords, but sorted such that the first point in scoords in
%             the closest to the source and the last point is farthest from
%             the source.
%
% Written by Michael Meaden - Elmhurst College BITS Lab, 01/25/2011.

%% Determine angle corresponding to the corners of the frame.

% Get length and height of the frame in pixels.
flength = length(im(1,:));
fheight = length(im(:,1));

% Specify origin to be at the center of the frame.
ox = flength/2;
oy = fheight/2;

% Calculate angle from x axis to the top right corner of the frame.
cangle = atan(oy/ox);

%% Based on angle and quadrant of source, determine source coordinates.

% First case: Angle falls on right side of frame.
if (srcang >= (2*pi-cangle)) || (srcang <= cangle)
    srcx = flength;
    srcy = fheight-((srcx-ox)*tan(srcang)+oy);
    
% Second case: Angle falls on top of frame.
else
    if (srcang > cangle) && (srcang <= (pi-cangle))
        srcy = 0;
        srcx = (srcy-oy)*cot(srcang)+ox;
        
    % Third case: Angle falls on left side of frame.
    else
        if (srcang > (pi-cangle)) && (srcang <= (pi+cangle))
            srcx = 0;
            srcy = fheight-((srcx-ox)*tan(srcang)+oy);
            
        % Fourth case: Angle falls on the bottom of frame.
        else
            if (srcang > (pi+cangle)) && (srcang < (2*pi-cangle))
                srcy = fheight;
                srcx = (srcy-oy)*cot(srcang)+ox;
            end
        end
    end
end

%% Sort coordinates based on how far they are from the source coordinates.

% Initialize scoords matrix.
scoords = coords;
zerocol = zeros(size(coords,1),1);
scoords = cat(2,scoords,zerocol);

% Create a fifth column in the scoords matrix to store the distances from
% the source.
for ii = 1:1:size(coords,1)
    scoords(ii,5) = sqrt((scoords(ii,1)-srcx)^2+(scoords(ii,2)-srcy)^2);
end

% Sort scoords using sortrows function.
scoords = sortrows(scoords,5);
