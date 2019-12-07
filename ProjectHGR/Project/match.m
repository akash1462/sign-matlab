% [match1,match2,cx1,cy1,cx2,cy2,num]  = match(image1, image2, distRatio)
%
% inputs:
% image1 and image2 are two images to match. For our case the first image
% is one of the database images and image2 is the input(query) image.
%
% distRatio is the parameter of SIFT algorithm. In the original
% implementation, this parameter is set as a constant. For our algorithm's 
% recursivity we made it a variable parameter.
%
% outputs:
% match1 returns the matched keypoint locations of the first image
% match2 returns the matched keypoint locations of the second image
% cx1 returns the X position of the database image's center point
% cy1 returns the Y position of the database image's center point
% cx2 returns the X position of the input(query) image's center point
% cy2 returns the Y position of the input(query) image's center point
% num returns the number of matched keypoints

% Note: For visualization and speed purposes some portions of this function are left
% as 'commented'. Remove the comments in order to see the details of the
% funtion's process.
%
% ----------------------------------------------------------------

function [match1,match2,cx1,cy1,cx2,cy2,num]  = match(image1, image2, distRatio);
%close all;
match1=0;
match2=0;
cy1=0;
cx1=0;
cy2=0;
cx2=0;
% Find SIFT keypoints for Image-1
disp('Processing Image-1 (Database)');
disp(image1);
[im1, des1, loc1] = sift(image1);
im1=imread(image1); %optional
%figure('Position', [100 100 size(im1,2) size(im1,1)]);
%imagesc(im1);
%hold on;
%for i = 1: size(loc1,1)
%    plot(loc1(i,2),loc1(i,1),'ro');
%end
%title('SIFT Keypoints for "Image-1"');
%hold off;
%disp('------------------');

% Find SIFT keypoints for Image-2
disp('---');
disp('Processing Image-2 (Input/Query)');
[im2, des2, loc2] = sift(image2);
im2=imread(image2); %optional
%figure('Position', [100 100 size(im2,2) size(im2,1)]);
%imagesc(im2);
%hold on;
%for i = 1: size(loc2,1)
%    plot(loc2(i,2),loc2(i,1),'ro');
%end
%title('SIFT Keypoints for "Image-2"');
%hold off;
%disp('------------------');

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = distRatio;
%distRatio = 1;

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      myMatch(i) = indx(1);
   else
      myMatch(i) = 0;
   end
end



% show the matched points for image-1
%figure('Position', [100 100 size(im1,2) size(im1,1)]);
%imagesc(imread(image1));
%hold on;
j=1;
for i = 1: size(des1,1)
  if (myMatch(i) > 0)
    %plot(loc1(i,2),loc1(i,1),'ro');
    match1(j,1)=loc1(i,1);
    match1(j,2)=loc1(i,2);
    match2(j,1)=loc2(myMatch(i),1);
    match2(j,2)=loc2(myMatch(i),2);
    j=j+1;
  end
end
%title('Matched Points for "Image-1"');
%hold off;

% show the matched points for image-2
%figure('Position', [100 100 size(im2,2) size(im2,1)]);
%imagesc(imread(image2));
%hold on;
%for i = 1: size(des1,1)
%  if (myMatch(i) > 0)
%    plot(loc2(myMatch(i),2),loc2(myMatch(i),1),'go');
%  end
%end
%title('Matched Points for "Image-2"');
%hold off;

% Create a new image showing the two images side by side.
im3 = appendimages(im1,im2);

% Calculate the center points
num = sum(myMatch > 0); %matched points

if (num > 1)
    s1=sum(match1);
    s2=sum(match2);
    cy1=s1(1)/num;
    cx1=s1(2)/num; %Center point for the database image

    cy2=s2(1)/num;
    cx2=s2(2)/num; %Center point for the input image
end

% % Show matched points for "Image-1" and "Image-2"
% figure('Position', [100 100 size(im3,2) size(im3,1)]);
% imagesc(im3);
% hold on;
% cols1 = size(im1,2);
% for i = 1: size(des1,1)
%   if (myMatch(i) > 0)
%     plot(loc1(i,2),loc1(i,1),'ro');
%     plot(loc2(myMatch(i),2)+cols1,loc2(myMatch(i),1),'go');
%   end
% end
% 
% if (num > 1)
%     plot(cx1,cy1,'bx');
%     plot(cx2+cols1,cy2,'bx');
% end
% 
% title('Matched Points for "Image-1" and "Image-2"');
% hold off;

fprintf('Found %d matches.\n', num);
disp('----------------------------------');




