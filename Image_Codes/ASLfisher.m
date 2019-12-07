function [V_Fisher ProjectedImages_Fisher] = ASLfisher(ImgMat,V_PCA,nRows,nColumns,omega,Class_number,Class_population,ShowOutput)
% Use Principle Component Analysis (PCA) extracted features to calculte the 
% Fisher Linear Discriminant (FLD) features to determine the most 
% discriminating features between images of faces.
%
% Original version by Amir Hossein Omidvarnia, October 2007
%                     Email: aomidvar@ece.ut.ac.ir                  
P = Class_population * Class_number; % Total number of training images
ProjectedImages_PCA = omega;
%%%%%%%%%%%%%%%%%%%%%%%% Calculating the mean of each class in eigenspace
m_PCA = mean(ProjectedImages_PCA,2); % Total mean in eigenspace
m = zeros(P,Class_number); 
Sw = zeros(P,P); % Initialization os Within Scatter Matrix
Sb = zeros(P,P); % Initialization of Between Scatter Matrix

for i = 1 : Class_number
    m(:,i) = mean( ( ProjectedImages_PCA(:,((i-1)*Class_population+1):i*Class_population) ), 2 )';    
    
    S  = zeros(P,P); 
    for j = ( (i-1)*Class_population+1 ) : ( i*Class_population )
        S = S + (ProjectedImages_PCA(:,j)-m(:,i))*(ProjectedImages_PCA(:,j)-m(:,i))';
    end
    
    Sw = Sw + S; % Within Scatter Matrix
    Sb = Sb + (m(:,i)-m_PCA) * (m(:,i)-m_PCA)'; % Between Scatter Matrix
end

%%%%%%%%%%%%%%%%%%%%%%%% Calculating Fisher discriminant basis's
% We want to maximise the Between Scatter Matrix, while minimising the
% Within Scatter Matrix. Thus, a cost function J is defined, so that this condition is satisfied.
Sw = Sw + ones(P);%To ensure it is full rank
[J_eig_vec, J_eig_val] = eig(Sb,Sw); % Cost function J = inv(Sw) * Sb
V_Fisher = fliplr(J_eig_vec);

%%%%%%%%%%%%%%%%%%%%%%%% Eliminating zero eigens and sorting in descend order
for i = 1 : Class_number-1 
    V_Fisher(:,i) = J_eig_vec(:,i); % Largest (C-1) eigen vectors of matrix J
end


%% Show the Fisher extracted features
if(ShowOutput == 1)
    for i=1:P
        % Display Extracted features
        f = figure();
        Img = V_PCA*V_Fisher(:,i);
        Img = reshape(Img,nRows,nColumns);
        set(f,'name','Extracted Fisher features')                                
        imagesc(Img);                    
        axis equal;
        colormap('gray');
        set(gca, 'fontsize', 28);            
    end
end

%%%%%%%%%%%%%%%%%%%%%%%% Projecting images onto Fisher linear space
% Yi = V_Fisher' * V_PCA' * (Ti) 
ProjectedImages_Fisher = zeros(P,P);
for i = 1 : P%Class_population * (Class_number - 1)
    ProjectedImages_Fisher(:,i) = V_Fisher' * ProjectedImages_PCA(:,i);
end