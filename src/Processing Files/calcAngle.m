function angle = calcAngle(coords,pt1,pt2,velAngle)

%% Summary of function calcAngle:
%  Function that calculates the angle between the velocity vector of a
%  specified point and the centroid coordinates of a second specified
%  point.

%% Input and Output specifications:
% INPUT:
%
% - coords:   Matrix of centroid coordinates returned by getCntrdCoords.
% - pt1:      Matrix index of first point.
% - pt2:      Matrix index of seconds point.
% - velAngle: Direction of the velocity vector.
%
% OUTPUT:
%
% - angle: Angle between the velocity vector of pt1 and the centroid
%          coordinates of pt2.
%
% Written by Michael Meaden - Elmhurst College BITS Lab, 01/20/2011.

%% Main code block:

% Get x and y coordinates of specified points from coords matrix.
pt1x = coords(pt1,1);
pt1y = coords(pt1,2);
pt2x = coords(pt2,1);
pt2y = coords(pt2,2);

%Create a unit vector in the direction of velAngle.
velV = [cos(velAngle) -sin(velAngle) 0];

%Create a vector that treats the centroid of pt1 as the origin and
%points to the centroid of pt2.
ptV = [(pt2x-pt1x) (pt2y-pt1y) 0];
    
%Take the dot product of the two vectors.
dotProd = dot(velV,ptV);

%Using the fact that the dot product of two vectors is equal to the product
%of the magnitudes of the two vectors times the cosine of the angle between
%the two, we can find the angle between the velocity vector of pt1 and the
%displacement vector from pt1 to pt2.
angle = acos((dotProd)/(norm(velV)*norm(ptV)));

%Add a sign to the angle by considering the cross product of the vectors.
%Since the flow is two-dimensional, we know the cross product willl yield a
%vector in the z direction.  Using this value, we can determine the sign of
%the angle based on the normal counter-clockwise = + sign convention for
%angles.
crossProd = cross(velV,ptV);

if crossProd(1,3) < 0
    angle = -angle;
end
