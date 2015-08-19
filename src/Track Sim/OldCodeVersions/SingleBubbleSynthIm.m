%% Single Bubble synthetic track creator 6/12/12

[Bub RowSize ColSize] = imconvrt('bubble3.jpg');

[Frame r c] = TrackSim(21);

a=1080;
b=1920;

MidRow = round(RowSize/2);
MidCol = round(ColSize/2);
ImFrame=Frame;
for n = 1:1:a
    for m = 1:1:b
        if Frame(n,m) > 0
            for q = 1:1:ColSize
                for u = 1:1:RowSize
                    if (n - (MidCol - q) > 0) && (m - (MidRow - u) > 0)
                        ImFrame((n-(MidCol-q)),(m-(MidRow - u)))=Bub(u,q);
                    end
                end
            end
            
        end
    end
end

imwrite(ImFrame,'bubbleck.bmp');