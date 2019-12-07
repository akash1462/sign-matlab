% input is the input(query) image
% distRatio is the distance ratio parameter of SIFT
% threshold is the threshold value for the MK-RoD
% Selecteds specifies the selected database image for the process
% ----------------------------------------------------------------
function results=formResults(input, distRatio,threshold,Selecteds);
% For details, investigate the MKRoDAlgorithm.jpg
load theHGRDatabase;

for i=1:size(Selecteds,2)
    if(i==Selecteds(i))
        % Match the images and get the matched keypoints' data
        [match1,match2,cx1,cy1,cx2,cy2,num]  = match(dataBase(Selecteds(i),:), input, distRatio);
                
        % If the number of Matched Keypoints are greater than 2, start the
        % algorithm
        if num>2            
            %Calculate the distances of the matched keypoints to the center of the
            %keypoints
            for j=1:num
                distance1(j)=sqrt((match1(j,2)-cx1).^2+(match1(j,1)-cy1).^2);
                distance2(j)=sqrt((match2(j,2)-cx2).^2+(match2(j,1)-cy2).^2);
            end
            
            % Sum the distances and calculate the Distance Ratio Array.
            distanceSum1=sum(distance1);
            distanceSum2=sum(distance2);
            
            if(distanceSum1==0)
                distanceSum1=1;
            end
            
            if(distanceSum2==0)
                distanceSum2=1;
            end
            
            for j=1:num
                distanceRatio1(j)=distance1(j)./distanceSum1;
                distanceRatio2(j)=distance2(j)./distanceSum2;
            end
            
            % Mask the distances by taking the absolute which are below the
            % algorithm's threshold.
            % This operation is done in order to determine the similar
            % pattern of 'the matched keypoints+ the center of the matched
            % keypoints'.
            % The absolute of the difference of the points which are below
            % the given threshold are treated as valid matched keypoint.
            distanceMask=abs(distanceRatio1-distanceRatio2)<threshold;
            
            %Calculate the total valid points by summing the distanceMask
            distanceMaskSum=sum(distanceMask);
        else
            % If the number of matched keypoints are not greater than 2
            % than the number of valid points are directly 0.
            distanceMaskSum=0;
        end
        % Store the results
        results(i,1)=cx1; % X position of the database image's center point
        results(i,2)=cy1; % Y position of the database image's center point
        results(i,3)=cx2; % X position of the input(query) image's center point
        results(i,4)=cy2; % Y position of the input(query) image's center point
        results(i,5)=num; % Number of matched keypoints
        results(i,6)=distanceMaskSum; % Number of valid matched keypoints
        
        % Calculate the validity ratio of the keypoints simply by dividing
        % the valid matched keypoints by the matched keypoints.
        % Store the ratio inside the results array.
        if(num==0);
            validRatio=0;
        else
            validRatio=distanceMaskSum/num;
        end
        results(i,7)=validRatio;
        results(i,8)=i;

% Reset the parameters for the next iteration
        distanceRatio1=0;
        distanceRatio2=0;
        distanceMask=0;
        distanceMaskSum=0;
        
    else
        results(i,:)=0;
    end
end
