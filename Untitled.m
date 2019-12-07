I = imread('coins.png');
imshow(I)
BW1 = edge(I,'Canny');
BW2 = edge(I,'Prewitt');
imshowpair(BW1,BW2,'montage')
I = gpuArray(imread('coins.png'));
BW = edge(I,'prewitt');
figure, imshow(BW)