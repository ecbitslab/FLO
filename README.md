# FLO
This is a tool used to track the motion of air, that has detectable tracers in it. The tracers used in our Lab are bubbles that are illuminated by laser light. This code will take a video of the air flow with tracers and will find the tracks of the bubbles. This allows you to find many things like the velocity of the air flow at different locations and the curl of the air flow as well.

To run this code add the FLO directory to the Matlab path. Afterwords call the FLO/src/Processing Files/BT_Driver script. To change the video to process or the run parameters, just change the values in the script. After BT_Driver is run the processed data is stored in the variable "S" in the workspace.

To view the tracks that the BT_Driver found use the command 
	plotTracks(S, frameNumber, 1);
where "S" is the variable created from BT_Driver.

To view an image with the location of every bubble found in a video:
	cen = allCentriod(S);
	plot(cen(:,1), cen(:,2), '.');

To view a density map of every bubble found in a video:
	imagesc(bin2d(cen, binSize, [vidDimX, vidDimY]));colorbar();

In the src/BT_Testing/ folder there are functions to help evaluate the accuracy of the BT_Driver. Such as BT_StatMean.m.
