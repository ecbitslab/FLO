function [ imNoise ] = NoiseAdd( imMatrix, RowSize, ColSize )
%INTENSITY NOISE - This function is designed to add noise to the intensity
% of the artificial bubles created by the Track Simulator code. It uses the
% outputs of the imconvrt function as inputs, and will give out the matrix
% for a bubble image in the output.



noisefrac = 0.5; %fraction of noise that we wish to add to bubble.  
                 % Range is from 0 to 1
                 % Default is 0.1

for j = 1:RowSize
    
    for k = 1:ColSize
        
        imNoise(j,k) = imMatrix(j,k) + noisefrac * imMatrix(j,k)...
            * ((2 * rand(1)) - 1);
        
    end
    
end

end

