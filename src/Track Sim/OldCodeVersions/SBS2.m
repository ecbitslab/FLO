%% Single Bubble synthetic track creator 6/12/12
%v2 less for loops
[Bub RowSize ColSize] = imconvrt('bubble7.jpg');

[Frame r c] = TrackSimv2(21);

MidRow = round(RowSize/2);
MidCol = round(ColSize/2);
ImFrame=Frame;
for n = 1:1:length(r)
    for q = 1:1:ColSize
        for u = 1:1:RowSize
            if (r(n) - (MidRow - u) > 0) && (r(n) - (MidRow - u) < 1081)...
                    && (c(n) - (MidCol - q) > 0)...
                    &&(c(n) - (MidCol - q) < 1921)
                ImFrame((r(n)-(MidRow-u)),(c(n)-(MidCol - q)))=Bub(u,q) ...
                    + ImFrame((r(n)-(MidRow-u)),(c(n)-(MidCol - q)));
            end
        end
    end
end

imwrite(ImFrame,'bubbleck.bmp');