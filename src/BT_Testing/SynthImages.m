function [  ] = SynthImages( name, trackNum, imageNum )
%SYNTHIMAGES Makes many synthetic tracks, then saves the tracks and the
%image produced to the harddrive.
%
% Inputs:
% 
% name - The file which you wish to write to. This should not have the
%        extentsion. If name = 'fun', then the files 'fun1.bmp',
%        'fun2.bmp', ect. will be made. If name = 'fun', then the files 
%        'fun1.mat', 'fun2.mat', ect. will also be made. 
%
% trackNum - the number of tracks on each image.
%
% imageNum - the number of images to create.
%

% This neads to be loaded for SynthImage.
load('Track Sim/lib.mat');

for ii = 1:imageNum
    % Makes the synthetic track. Then writes the image and track to the disk.
    [Frame, tracks] = SynthImage(trackNum, lib);
    
    imwrite(Frame, strcat(name, int2str(ii), '.bmp'));
    
    close all;
    
    save(strcat(name, int2str(ii), '.mat'), 'tracks');
end

end

