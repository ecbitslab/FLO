function [ velocities ] = velocity( positions, dt )
%given a list of positions a velocity is calculated between the two
%positions given in the parameters

%input

%positions : an array in which positions (5,1) is the fifth point
%x-coordinate and the position (5,2) is the 5th point y coordinate

%dt: The time it took between each bubble. Tells how much time lapsed
%between each bubble position change.

%output

%velocities:First two columns give x and y coordinates of velocity
%respectively and last two columns gives x and y positions respectively.
%Each row is a different position.
vels = diff(positions)/dt;

velocities = horzcat(vels,positions(1:size(positions,1) - 1,:));


end

