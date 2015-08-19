function [ Frame, Pos] = TrackSimv3( NumberOfTracks )
%v2 changes the method for distances between centroids
%v3 adds a struct for row and col finder
%% Input Variables 
% Variable 'a' gives us the length of the image that will be produced
    % Note: Set to 1080 by default because the real frames are of the same
    %       length

a = 1080;               % Default = 1080



% 'MinD' and 'MaxD' give us the minimum and maximum possible pixel distance
% between centroids 

MinD = 5;             % Default = 10
MaxD = 20;            % Default = 25

% Variable 'MinC' gives the minimum number of centroids per track.  Variable
% 'MaxC' gives the maximum number of centroids per track.

MinC = 2;               % Default = 2
MaxC = 13;              % Default = 13

% Variable 'MinA' gives the minimum angle of deviation for some centroid.
% Variable 'MaxA' gives the maximum angle of deviation for some centroid.

MinA = -pi/32;               % Default = -pi/32
MaxA = pi/32;           % Default = pi/32 = 5 degrees

% Variable 'TotT' gives the total number of tracks in an image.

TotT = NumberOfTracks;         % Default = 21

% Varible 'MaxJ'and 'MinJ' gives a minimum and maximum percent of a 
% centroids motion that will give aditional jittering in the angle of 
%deviation 
MaxJA = .20;         % Default = .05
MinJA = -.20;        % Default = -.05

%'MaxJD' and 'MinJD' add jitter to the distance from some
%centriod to the next
%Note: This makes the tracks too jittery sometimes so unless something
%changes, I'd keep it at zero
MaxJD = .00;
MinJD = -.00;
%% Fixed Variables

% Variable 'ImRatio' gives of the image ratio between length and width.
    % Note: Set to 1920/1080 by default cause the real data is a 1080 by
    %       1920 matrix image

ImRatio = 1920/1080;    % Default = 1920/1080

% b is a function a that statisfies the ratio ImRatio

b = round(a*ImRatio);

% Frame is our coordinate matrix

Frame = zeros(a,b);

%% Origin Initial Track

%Random Number of Centroids
Centroid = randi([MinC MaxC],1);
%Distance between each centroid
CDist = randi([MinD MaxD], 1);
%Angular Displacement
ADisp = MinA + (MaxA - MinA).*rand(1);

%Initial position of centroid
x = 1; 
y = round(b/2); 


P=1;
Frame(x,y) = P;             %P is for testing tracks with color



%This loop creates the additional centroid positions that follow the
%initial position.  If the position generated by the random number
%generator does not fall within the matrix 'Frame' the loop breaks
for k = 2:1:Centroid
    %'JitA'adds a jitter along the angle of deviation for each 'bubble step'
    JitA = MinJA + (MaxJA - MinJA)*randn(1);
    
    JitX = MinJD + (MaxJD - MinJD)*randn(1);
    
    JitY = MinJD + (MaxJD - MinJD)*randn(1);
    
    x = x + round(CDist*cos((k-1)*ADisp*(1 + JitA)) + JitX*x);
    if x <= 0 || x > a
        break
    end
    y = y + round(CDist*sin((k-1)*ADisp*(1+JitA)) + JitY*y);
    if y <= 0 || y > b
        break
    end
    Frame(x,y) = P;
end

%% Random Track Maker
%We repeat the same method for creating an initial track, but we create
%these tracks in random positions

for w = 2:1:TotT
    x=randi([1 a],1);   %initial x
    y=randi([1 b],1);   %initial y
    
    Centroid = randi([MinC MaxC],1);
    %Distance between each centroid
    CDist = randi([MinD MaxD], 1);
    %Angular Displacement
    ADisp = MinA + (MaxA - MinA)*rand(1);
    
    
    P=P+1 ;      %P again
    Frame(x,y) = P;
    
    for k = 2:1:Centroid
        
        JitA = MinJA + (MaxJA - MinJA)*randn(1);
        
        JitX = MinJD + (MaxJD - MinJD)*randn(1);
    
        JitY = MinJD + (MaxJD - MinJD)*randn(1);
        
        x = x + round(CDist*cos((k-1)*ADisp*(1 + JitA)) + JitX*x);
        %To ensure that our coordinate 'x' is not outside the matrix
        %'Frame' we use an 'if' statement with a 'break' to prevent this
        if x <= 0 || x > a
            break
        end
        y = y + round(CDist*sin((k-1)*ADisp*(1+JitA)) + JitY*y);
        %To ensure that our coordinate 'y' is not outside the matrix
        %'Frame' we use an 'if' statment with a 'break' to prevent this
        if y <= 0 || y > b
            break
        end
        
        
        Frame(x,y) = P;    %P 
    end
end

%% Colored Plot
for ii=1:1:NumberOfTracks
    [Pos(ii).r Pos(ii).c] = find(Frame == ii);
end
[r1 c1] = find(Frame == 1);
[r2 c2] = find(Frame == 2);
[r3 c3] = find(Frame == 3);
[r4 c4] = find(Frame == 4);
[r5 c5] = find(Frame == 5);
[r6 c6] = find(Frame == 6);
[r7 c7] = find(Frame == 7);
[r8 c8] = find(Frame == 8);
[r9 c9] = find(Frame == 9);
[r10 c10] = find(Frame == 10);
[r11 c11] = find(Frame == 11);
[r12 c12] = find(Frame == 12);
[r13 c13] = find(Frame == 13);
[r14 c14] = find(Frame == 14);
[r15 c15] = find(Frame == 15);
[r16 c16] = find(Frame == 16);
[r17 c17] = find(Frame == 17);
[r18 c18] = find(Frame == 18);
[r19 c19] = find(Frame == 19);
[r20 c20] = find(Frame == 20);
[r21 c21] = find(Frame == 21);


figure;
%we plot column row instead of row column so the image looks like the one
%we get from the real life images
plot(c1,r1,'ob',c2,r2,'or',c3,r3,'ok',c4,r4,'og',c5,r5,'om',c6,r6,'oc',...
    c7,r7,'oy',c8,r8,'ob',c9,r9,'or',c10,r10,'ok',c11,r11,'og',...
    c12,r12,'om',c13,r13,'om',c14,r14,'oc',...
    c15,r15,'oy',c16,r16,'ob',c17,r17,'or',c18,r18,'ok',c19,r19,'og',...
    c20,r20,'om',c21,r21,'om')

%% Non-colored Plot
[r c] = find(Frame > 0);
figure;
plot(c,r,'ob')

end

