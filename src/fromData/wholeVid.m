function [ total  ] = wholeVid( S, dt )
%takes each track's position and velocity information of each bubble and
%creates a new massive matrix for the entire video all frames and all
%bubbles.

%input

% S: The S array spit out by BT_Driver
%dt: the time difference between two points on a track

%output:

%total:First two columns give x and y coordinates of velocity
%respectively and last two columns gives x and y positions respectively.
%Each row is a different bubble.

total = [];
%Doing what we did for velocities in an individual frame, but now for the
%whole video.
for frame = 1:size(S,2)
    sframe = S(frame);
    vels = collectData(sframe, dt);
    for jj = 1:size(vels,2)
        total = vertcat(total, vels{jj});
    end
end

end

