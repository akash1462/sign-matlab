% American Sign Language Detection
% Group 13
% This is the processing function to perform skin analysis 
% Credits to Ciarán Ó Conaire, Noel E. O'Connor and Alan F. Smeaton for the
% skin detection code got from http://clickdamage.com/sourcecode/index.php
function NormImage = preprocessing(img1,nRows,nColumns,threshold,ShowOutput)
if(ShowOutput == 1)
    % Display Original Image
    f = figure();
    set(f,'name','Input Images')
    imshow(img1);    
    set(gca, 'fontsize', 28);            
end
BWImg = rgb2gray(img1);%Convert to BW for processing
BWImg = imresize(BWImg,[nRows nColumns]);%This done because Five is diff size

im = double(imadjust(img1, [0 0.8], [0 1])); % a b c d: between 0 and 1
% To decrease contrast: increase a
% To increase contrast: decrease b
% To increase brightness: increase c
% To decrease brightness: decrease d
        
skinprob = computeSkinProbability(im);% Extract probable skin regions

ThresImage = skinprob>threshold;%Compute Thresholded regions

if(ShowOutput == 1)
    % Display Skin Detected Image
    f = figure();
    set(f,'name','Skin Thresholded Image')            
    imshow((skinprob>threshold)*64);
    colormap('gray');    
    set(gca, 'fontsize', 28);            
end

Mask = ones(5,5);
ThresImage = imerode(ThresImage,Mask);%Remove isolated pixels
Mask = ones(5,5);
ThresImage = imdilate(ThresImage,Mask);%Get borders of skin regions        

ThresImage = imresize(ThresImage,[nRows nColumns]);%This done because Five is diff size
FinalImg = double(BWImg) .* ThresImage;%Get only skin pixels
[row,col,~] = find(FinalImg);
if (size(row,1) > 10)
    FinalImg = imresize(FinalImg(min(row):max(row),min(col):max(col)),[nRows nColumns]);
else
    FinalImg = imresize(BWImg,[nRows nColumns]);
end
    
if(ShowOutput == 1)
    % Display Final extracted Image
    f = figure();
    set(f,'name','Extracted Hand region')                            
    imshow(FinalImg);                
    set(gca, 'fontsize', 28);            
end
%Resize skin region to entire image
NormImage = reshape(FinalImg,nRows*nColumns,1);%Reshape to column vector