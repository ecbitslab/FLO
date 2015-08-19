function dist = calcDistance(coords,pt1,pt2)

%% Summary of function calcDistance:
%  Function that calculates the distance between two specified points whose
%  coordinates are returned by getCntrdCoords.

%% Input and Output specifications.
% INPUT:
%
% - coords: Matrix of centroid coordinates returned by getCntrdCoords.
% - pt1:    Matrix index of first point.
% - pt2:    Matrix index of seconds point.
%
% OUTPUT:
%
% - dist: Distance between the two specified input points.
%
% Written by Michael Meaden - Elmhurst College BITS Lab, 01/18/2011.

%% Main code body.

% Create matrix of x coordinates and matrix of y coordinates.
x_coords = coords(:,1);
y_coords = coords(:,2);

% Calculate distance between two specified points using the distance
% formula.
dist = sqrt((x_coords(pt2)-x_coords(pt1))^2+(y_coords(pt2)-y_coords(pt1))^2);