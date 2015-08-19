function [ ImFrame, Pos ] = SynthImage( trackNum, lib )
%SYHNTHIMAGE Creates a synthetic track and the cooresponding image. Each centriod is radomly used from lib.
% 
% Inputs:
% 
% trackNum - the number of tracks to be created.
% 
% lib - A library of cetriods. These are used to put a centroid onto the
%       image.
%
% Output:
% 
% ImFrame - the image produced by the synthetic tracks.
%
% Pos - the synthetic tracks produced from TrackSim

[Frame Pos] = TrackSimVT(trackNum);
[a b]=size(Frame);
ImFrame=zeros(a,b);

for ii = 1:1:length(Pos)
    jj=randi([1 length(lib)]);
    for n = 1:1:length(Pos(ii).r)
        kk= randi([1 length(lib(jj).track)]);
        [RowSize ColSize] = size(lib(jj).track(kk).image);
        MidRow = round(RowSize/2);
        MidCol = round(ColSize/2);
        for q = 1:1:ColSize
            for u = 1:1:RowSize
                if (Pos(ii).r(n) - (MidRow - u) > 0)... 
                        && (Pos(ii).r(n) - (MidRow - u) < a+1)...
                        && (Pos(ii).c(n) - (MidCol - q) > 0)...
                        && (Pos(ii).c(n) - (MidCol - q) < b+1)
            
                    NBub = NoiseAdd(lib(jj).track(kk).image, RowSize, ColSize);
                
                    ImFrame((Pos(ii).r(n)-(MidRow-u)),(Pos(ii).c(n)-(MidCol - q)))= ...
                        NBub(u,q) + ...
                        ImFrame((Pos(ii).r(n)-(MidRow-u)),(Pos(ii).c(n)-(MidCol - q)));
            
                end
            end
        end
    end
end

end

