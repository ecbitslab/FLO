%% imconvrt.m 
function [ imMatrix, RowSize, ColSize ] = imconvrt( jpgim )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
Im_a=imread(jpgim);
%this assumes the boundarys are all set to 255 (white edges)
Im_a=double(Im_a);
Im_a=Im_a./255;
Im_a= .299*Im_a(:,:,1) + .587*Im_a(:,:,2) + .114*Im_a(:,:,3);
thresh=.8;
bi_a=im2bw(Im_a,thresh);
[r c] = find(bi_a==0);
imMatrix=Im_a(min(r):max(r),min(c):max(c));
RowSize = 1+max(r) - min(r);
ColSize = 1+max(c) - min(c);
end

