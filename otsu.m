# Copyright 2017 Xinyi Wang All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS-IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

obj=Tiff('/Users/wangxinyi/Desktop/CTIA/project/data/CLC-GFP A19 0.5MS root1.tif','r');
x=imread('/Users/wangxinyi/Desktop/CTIA/project/data/root1_interp_bw.tif');
% setDirectory(obj,100);
im1=read(obj);%first image in tiff files

im2=im2double(im1);
% im2=interp2(im1,3);
im_med=imgaussfilt(im2);
level=graythresh(im_med);
bw=im2bw(im_med,0.1);

bw2=imfill(bw,4,'holes'); 
bw2=imopen(bw,strel('disk',1));
bw2=bwareaopen(bw2,10);


CC=bwconncomp(bw2);
% s=regionprops(CC,'Area','Perimeter','Orientation', 'MajorAxisLength','MinorAxisLength', 'Eccentricity');
s=regionprops(bw2,'Orientation', 'MajorAxisLength','MinorAxisLength', 'Eccentricity','Centroid');

imagesc(im2)
hold on

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

for k = 1:length(s)
    xbar = s(k).Centroid(1);
    ybar = s(k).Centroid(2);

    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;

    theta = pi*s(k).Orientation/180;
    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];

    xy = [a*cosphi; b*sinphi];
    xy = R*xy;

    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;

    plot(x,y,'r','LineWidth',2);
end
hold off

% idx_svm=find([s.Area]<100);
% bw_svmS=ismember(labelmatrix(CC),idx_svm);
% 
% bw2(bw_svmS)=0;
% bw2=imfill(bw2,4,'holes');

% bw2=imopen(bw,strel('disk',5));



D=-bwdist(~bw2);
% D(~bw_svm)=Inf;
L=watershed(D,8);
bw_svm_seg=bw2;
bw_svm_seg(L==0)=0;
mask=imextendedmin(D,2);
% imshowpair(bw_svm,mask,'blend')
D2=imimposemin(D,mask);
L2=watershed(D2);
bw3=bw2;
bw3(L2==0)=0;

CC=bwconncomp(bw3);
s=regionprops(CC,'Area','Perimeter');
idx_svm=find([s.Area]<200);
xs=ismember(labelmatrix(CC),idx_svm);

bw3(xs)=0;
bounds=bwboundaries(bw3);%boundary of connected components
figure(1);
imagesc(im2);

%title('segment with gaussian filter');
% brighten(0.3)
hold on
for i=1:length(bounds)
%drawnow
    q=plot(bounds{i}(:,2),bounds{i}(:,1),'-r');
    str={i};
%     text(s3(i).Centroid(1),s3(i).Centroid(2),str,'Color','red');
    set(q,'Linewidth',1);
end
