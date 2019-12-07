% American Sign Language Detection
% This function performs SVM classification
function Ind = ASLsvm(cAlpha,nTrainingSamples,InImWeight,omega)

Training = omega';%Training based on features extracted
%SVM
Ind = 1;
for ii = 2:size(cAlpha,2)
    Group = [ii*ones(1,nTrainingSamples) Ind*ones(1,nTrainingSamples)];
    %Perform classification between chosen and next group of trainng
    %samples
    Train = [Training((ii-1)*nTrainingSamples+1:(ii-1)*nTrainingSamples+nTrainingSamples,:); ...
            Training((Ind-1)*nTrainingSamples+1:(Ind-1)*nTrainingSamples+nTrainingSamples,:)];  
    SVMStruct = svmtrain(Train, Group);    
    Ind = svmclassify(SVMStruct, InImWeight);%Chosen group retained for next comparison
end
