function [ velocities ] = collectData( frameOfBTDriver, dt )
%COLLECTDATA gives the velocity for each track given an (S) array spit out by BT_Driver

%input

%frameofBTDriver: A single (S) object from BT_Driver. IE single frame.
%Finds velocity of a single track in a single frame. Uses tracks to find
%the velocity.

%dt: the time difference between two points on a track.


%output

%velocities: Took a single frame and collected tracks in an individual
%frame. Then found the velocities of each point on the track.
tracks = sToTracks(frameOfBTDriver);
velocities = {};

%This loop iterates through each track and calculates the velocity for each
%track.
for ii = 1:size(tracks, 2)
    track = tracks{ii};
    vs = velocity(track, dt);
    velocities{ii} = vs;
end

%

end

