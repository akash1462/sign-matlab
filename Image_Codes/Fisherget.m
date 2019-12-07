function ProjectedTestImage = Fisherget(TestImage, V_PCA, V_Fisher)
% Extracts FLD features of Test image

%%%%%%%%%%%%%%%%%%%%%%%% Extracting the FLD features from test image
ProjectedTestImage = V_Fisher' * V_PCA' * TestImage; % Test image feature vector