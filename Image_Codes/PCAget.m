% American Sign Language Detection
% Group 13
% This function gets weights of input image
function InImWeight = PCAget(NormImage,u)
%Calculate weights in Transformed Feature space
InImWeight = zeros(1,size(u,2));
for i=1:size(u,2)    
    WeightOfInputImage = dot(u(:,i)',double(NormImage'));%Calculate weight in Transformed basis    
    InImWeight(i) = WeightOfInputImage;%Store image weights
end