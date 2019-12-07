% American Sign Language Detection
% Group 13
% This is the main function which serves as a wrapper for testing the
% Automatic Sign language recognition code.
% Tests for entire database
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
        sFilename = strcat(cAlpha(ii),'-train',int2str(jj),'.jpg');%Form filename 
        ColorImg = imread(char(sFilename));%RGB 24 bit image
        FinalImg = preprocessing(ColorImg,nRows,nColumns,threshold,ShowOutput);%Find skin thresholded regions
        ImgMat(:,ll) = FinalImg;%Store image as column matrix in ImgMat
        ll = ll + 1;%Move on to next column
    end
end

%% Train image
[PCAfeatures omega] = PCATraining(ImgMat,nRows,nColumns,ShowOutput,nEigValThres);
[V_Fisher ProjectedImages_Fisher] = ASLfisher(ImgMat,PCAfeatures,nRows,nColumns,omega,size(cAlpha,2),nTrainingSamples,ShowOutput);

%%Test Classifier
StartImage = 1;
EndImage = 5;
NoOfImage = EndImage - StartImage - 1;
PCACorrect_SVM = zeros(size(cAlpha,2),1);
PCACorrect_KNN = zeros(size(cAlpha,2),1);
LDACorrect_SVM = zeros(size(cAlpha,2),1);
LDACorrect_KNN = zeros(size(cAlpha,2),1);

for ii = 1:size(cAlpha,2)
    for jj = StartImage:EndImage 
        %% Input Image
        InputImage = strcat(cAlpha(ii),'-test',int2str(jj),'.jpg');%Form filename          
        img1 = imread(char(InputImage));

        %% Perform preprocessing of input image
        ProcImg = preprocessing(img1,nRows,nColumns,threshold,ShowOutput);
        InImWeight = PCAget(double(ProcImg),PCAfeatures);
        InImWeight2 = Fisherget(double(ProcImg),PCAfeatures,V_Fisher);

        %% Perform KNN and SVM classification
        Class = ASlknn(cAlpha,nTrainingSamples,InImWeight,omega);
        Ind = ASLsvm(cAlpha,nTrainingSamples,InImWeight,omega);
        Class2 = ASlknn(cAlpha,nTrainingSamples,InImWeight2',ProjectedImages_Fisher);
        Ind2 = ASLsvm(cAlpha,nTrainingSamples,InImWeight2',ProjectedImages_Fisher);
        
        if(Class == ii)
            PCACorrect_SVM(ii) = PCACorrect_SVM(ii) + 1;
        end
        if(Ind == ii)
            PCACorrect_KNN(ii) = PCACorrect_KNN(ii) + 1;
        end
        if(Class2 == ii)
            LDACorrect_SVM(ii) = LDACorrect_SVM(ii) + 1;
        end
        if(Ind2 == ii)
            LDACorrect_KNN(ii) = LDACorrect_KNN(ii) + 1;
        end            
    end
end
total_images = size(cAlpha,2)*NoOfImage;
display('Percentage PCA SVM correct-');
sum(PCACorrect_SVM)/total_images
display('Percentage PCA KNN correct-');
sum(PCACorrect_KNN)/total_images
display('Percentage LDA SVM correct-');
sum(LDACorrect_SVM)/total_images
display('Percentage LDA KNN correct-');
sum(LDACorrect_SVM)/total_images