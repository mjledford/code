%Project
clear all;
close all; %close all figures
%load both images
%img1 = imread('frame1a.jpg');
%img2 = imread('frame1b.jpg');
%img1 = imread('frame2a.jpg');
%img2 = imread('frame2b.jpg');
%img1 = imread('frame3a.jpg');
%img2 = imread('frame3b.jpg');
img1 = imread('frame4a.jpg');
img2 = imread('frame4b.jpg');
%img1 = imread('frame5a.jpg');
%img2 = imread('frame5b.jpg');

[rows1, cols1, numOfColorChannels1] = size(img1);
diffImg = img1 - img2;
if numOfColorChannels1 > 1
       img1 = rgb2gray(img1);
       img2 = rgb2gray(img2);
end
img1 = double(img1);
img2 = double(img2);

%implement equation 4 
G = (fft2(img2).*conj(fft2(img1))) ./ (abs(fft2(img2)).*abs(fft2(img1)));
g = ifft2(double(G));
gr = real(g);
%find M and N
m = max(max(gr));
%Find indices of interest
[M,N] = find(gr(:,:)==m);
xshift = rows1 - M + 1;
yshift = cols1 - N + 1;
new_img2 = circshift(img2, [xshift yshift]);
Gnew = (fft2(new_img2).*conj(fft2(img1))) ./ (abs(fft2(new_img2)).*abs(fft2(img1)));
gnew = ifft2(double(Gnew));
grnew = real(gnew);
%g_mag = abs(G);
%c = corr2(img1(:,:),img2(:,:));
%img3 = zeros(rows1,cols1,3);
%Implement a pixel-by-pixel change detection algorithm
% for i=1:rows1
%     for j = 1:cols1
%         if(sum(diffImg(i,j,:))>0) %There are pixel differences in RGB array
%             img3(i,j,:)=img2(real(i)-M,real(j)-N,:);
%         else
%             img3(i,j,:)=img2(i,j,:);
%         end
%     
%     end
% end


