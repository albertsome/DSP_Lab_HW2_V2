% My Harris detector
% The code calculates
% the Harris Feature/Interest Points (FP or IP) 
% 
% When u execute the code, the test image file opened
% and u have to select by the mouse the region where u
% want to find the Harris points, 
% then the code will print out and display the feature
% points in the selected region.
% You can select the number of FPs by changing the variables 
% max_N & min_N
close all;
clear;
clc;
tic

%%%
%corner : significant change in all direction for a sliding window
%%%


%%
% parameters
% corner response related
sigma=2;
n_x_sigma = 6;
alpha = 0.04;
% maximum suppression related
% By trial and error, Thrshold=10 is the closest one to the provided
% picture "corner,png"
Thrshold=10;  % should be between 0 and 1000
r=6; 


%%
% filter kernels
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma


%% load 'Im.jpg'
frame = imread('data/Im.jpg');
I = double(frame);
figure(1);
imagesc(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;
% grey scale
Igrey = (I(:,:,1)*0.299+I(:,:,2)*0.587+I(:,:,3)*0.114)/255;

%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%
% get image gradient
% [Your Code here] 
% calculate Ix
% calcualte Iy
Ix = my_imfilter(Igrey,dx);
Iy = my_imfilter(Igrey,dy);

%%%%%
% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]]; note Ix2 Ixy Iy2 are all Gaussian smoothed
% [Your Code here] 
% calculate Ix2  
% Ix2 means square; same for Iy2
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

% Gaussian smoothed
Ix2 = my_imfilter(Ix2,g);
Iy2 = my_imfilter(Iy2,g);
Ixy = my_imfilter(Ixy,g);


%%%%%

%% visualize Ixy
% figure(2);
% imagesc(Ix2);
% figure(3);
% imagesc(Iy2);
% figure(4);
% imagesc(Ixy);

%%%%%%% Demo Check Point -------------------


%%%%%
% get corner response function R = det(M)-alpha*trace(M)^2 
% [Your Code here] 
M = [[Ix2 Ixy];[Ixy Iy2]];
% calculate R
R = Ix2.*Iy2-Ixy.^2-alpha*((Ix2+Iy2).^2);



%%%%%

%% make R value range from 0 to 1000
R=(1000/max(max(R)))*R;%

%%%%%
%% using B = ordfilt2(A,order,domain) to complment a maxfilter
sze = 2*r+1; % domain width 
% [Your Code here] 
% calculate MX
MX = ordfilt2(R,160,ones(sze,sze));
%%%%%

%%%%%
% find local maximum.
% [Your Code here] 

RBinary = zeros(size(R));
% % the method w/i for loop

% for i=1:xmax
%     for j=1:ymax
%         if((MX(i,j)==R(i,j))&&(MX(i,j)>Thrshold))
%             RBinary(i,j) = 1;
%         end
%     end
% end

% the method w/o for loop
RBinary((MX == R) & (MX > Thrshold)) = 1;

% calculate RBinary

%%%%%


%% get location of corner points not along image's edges
offe = r-1;
count=sum(sum(RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe))); % How many interest points, avoid the image's edge   
R=R*0;
R(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe)=RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe);
[r1,c1] = find(R);
PIP=[r1,c1]; % IP , 2d location ie.(u,v)
  

%% Display
figure(5)
imagesc(uint8(I));
hold on;
plot(c1,r1,'or');
saveas(gcf,'results/1.jpg');
toc
return;
