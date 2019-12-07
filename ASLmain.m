% American Sign Language Detection
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

%% Input Image
Symbol = input('Enter the symbol you want to test for (A,B,C,Five,Point,V)-','s');
Num = input('Enter the no of the image you want to test for(1-435)-');
InputImage = strcat(Symbol,'-train',num2str(Num),'.jpg');%Read input image
img1 = imread(InputImage);

%% Define variables
cAlpha = [{'A'},{'B'},{'C'},{'Five'},{'Point'},{'V'}];%No of alphabet used
nTrainingSamples = 1;%No of training Images we are using.
nRows = 76;%No of rows for the images
nColumns = 66;%No of columns for the images
ImgMat = zeros(nRows*nColumns,size(cAlpha,2)*nTrainingSamples);%Initialize image matrix
ShowOutput = 0;%Keyword to display images, 1-display 2-suppress display
if (nTrainingSamples ~= 1)
    ShowOutput = 0;%No output if no of samples > 1
end
nEigValThres = 0.0001;%Threshold below which to ignore eigen vectors
threshold = -2;%Threshold for skin detection

%% Perform preprocessing of Training images
ll = 1;
for ii = 1:size(cAlpha,2)
    for jj = 1:nTrainingSamples 
        sFilename = strcat(cAlpha(ii),'-test',int2str(jj),'.jpg');%Form filename 
        ColorImg = imread(char(sFilename));%RGB 24 bit image
        FinalImg = preprocessing(ColorImg,nRows,nColumns,threshold,0);%Find skin thresholded regions        
        ImgMat(:,ll) = FinalImg;%Store image as column matrix in ImgMat
        ll = ll + 1;%Move on to next column
    end
end


%% Train image
[PCAfeatures omega] = PCATraining(ImgMat,nRows,nColumns,ShowOutput,nEigValThres);
[V_Fisher ProjectedImages_Fisher] = ASLfisher(ImgMat,PCAfeatures,nRows,nColumns,omega,size(cAlpha,2),nTrainingSamples,ShowOutput);

%% Perform preprocessing of input image
ProcImg = preprocessing(img1,nRows,nColumns,threshold,ShowOutput);
InImWeight = PCAget(ProcImg,PCAfeatures);
InImWeight2 = Fisherget(ProcImg,PCAfeatures,V_Fisher);


%% Perform KNN and SVM classification
Class = ASlknn(cAlpha,nTrainingSamples,InImWeight,omega);
Ind = ASLsvm(cAlpha,nTrainingSamples,InImWeight,omega);
Class2 = ASlknn(cAlpha,nTrainingSamples,InImWeight2',ProjectedImages_Fisher);
Ind2 = ASLsvm(cAlpha,nTrainingSamples,InImWeight2',ProjectedImages_Fisher);


%% Display Input and Matched Output
f = figure();
set(gca, 'fontsize', 28);            
set(f,'name','KNN')
subplot (1,3,1)
imshow(img1); 
title('Input image','fontsize', 20)
subplot (1,3,2)
RecongImg = strcat(cAlpha(Class),'-test1.jpg');
imshow(char(RecongImg)); 
title(strcat('Recognized Letter using PCA-',cAlpha(Class)),'fontsize',20);
subplot (1,3,3)
RecongImg = strcat(cAlpha(Class2),'-test1.jpg');
imshow(char(RecongImg)); 
title(strcat('Recognized Letter using FLD-',cAlpha(Class2)),'fontsize',20);

f = figure();
set(gca, 'fontsize', 28);            
set(f,'name','SVM')
subplot (1,3,1)
imshow(img1);
title('Input image','fontsize', 20)
subplot (1,3,2)
RecongImg = strcat(cAlpha(Ind),'-test1.jpg');
imshow(char(RecongImg)); 
title(strcat('Recognized Letter using PCA-',cAlpha(Ind)),'fontsize', 20);
subplot (1,3,3)
RecongImg = strcat(cAlpha(Ind2),'-test1.jpg');
imshow(char(RecongImg)); 
title(strcat('Recognized Letter using FLD-',cAlpha(Ind2)),'fontsize', 20);