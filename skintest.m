% American Sign Language Detection
% Group 13
% This is the main function which serves as a wrapper for testing the
% Automatic Sign language recognition code.
% Takes image input
clc;
clear all;
close all;

%% Add training and test directories to path
addpath('./Training/A');
addpath('./Training/B');
addpath('./Training/C');
addpath('./Training/Five');
addpath('./Training/Point');
addpath('./Training/V');
addpath('./Testing/A');
addpath('./Testing/B');
addpath('./Testing/C');
addpath('./Testing/Five');
addpath('./Testing/Point');
addpath('./Testing/V');

img1 = 'Five-train1.jpg';
% img1 = 'V-train1.jpg';
img1 = imread(img1);
nRows = 76;%No of rows for the images
nColumns = 66;%No of columns for the images
threshold = -2;

BWImg = rgb2gray(img1);%Convert to BW for processing
BWImg = imresize(BWImg,[nRows nColumns]);%This done because Five is diff size

% BWImg = BWImg - mean(mean(BWImg));
% BWImg = histeq(BWImg);

% Display Original Image
subplot(2,2,1)
imshow(img1);    

im = double(imadjust(img1, [0 0.8], [0 1])); % a b c d: between 0 and 1
% To decrease contrast: increase a
% To increase contrast: decrease b
% To increase brightness: increase c
% To decrease brightness: decrease d
        
skinprob = computeSkinProbability(im);% Extract probable skin regions

ThresImage = skinprob>threshold;%Compute Thresholded regions

subplot(2,2,2);
imshow((skinprob>threshold)*64);
colormap('gray');    

Mask = ones(2,2);
ThresImage = imerode(ThresImage,Mask);%Remove isolated pixels
Mask = ones(5,5);
ThresImage = imdilate(ThresImage,Mask);%Get borders of skin regions        

subplot(2,2,3);
imshow(ThresImage);
colormap('gray');    

ThresImage = imresize(ThresImage,[nRows nColumns]);%This done because Five is diff size
FinalImg = double(BWImg) .* ThresImage;%Get only skin pixels
[row,col,~] = find(FinalImg);
FinalImg = imresize(FinalImg(min(row):max(row),min(col):max(col)),[nRows nColumns]);

subplot(2,2,4);
imshow(FinalImg);                
    
%Resize skin region to entire image
NormImage = reshape(FinalImg,nRows*nColumns,1);%Reshape to column vector