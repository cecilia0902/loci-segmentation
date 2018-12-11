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
path='/Users/wangxinyi/Desktop/CTIA/project/data/root0/root0.'
for j=1:1
    name  = sprintf('%s%d',path,j,'.jpg');

  
    im1=read(obj);%first image in tiff files

    im2=im2double(im1);
%     im2=interp2(im1,3);
    im2=imgaussfilt(im2);
    %
    % im_med=adapthisteq(im_med,'NumTiles',[8 8],'ClipLimit',0.005);
    % % im_med=wiener2(im_med,[10 10]);
    %
    % level=graythresh(im_med);
    % bw=im2bw(im_med,level);
    %
    % bw2=imfill(bw,4,'holes');
    % bw2=imopen(bw,strel('disk',5));
    % bw2=bwareaopen(bw2,10);

    % D=bwdist(~bw);
    % D=-D;
    % D(~bw)=Inf;
    % L=watershed(D,8);
    % L(~bw)=0;

    %% svm
    back=[0;.01569;.007843;.003922;.07451;.0549;.04706; .08627;.03137;.01961;.02745;.04314;.03529;.07843;.0007482;.03529;0;.01176;.02754;.04314;...
        .01569;0;.03137;.1307;.02233];
    fore=[.8196;.9608;.4941;.3843; .2196;.2902;.1529;.149;.2471;1;.09804;.01176;.07059;.01843;.1216;.1569;.1255;.1137;.02745;.0549;... 
        .2353;.2667;.251;.2288;.2906];

    group=[zeros(size(back,1),1);ones(size(fore,1),1)];
%     cellSVM=svmtrain([back;fore],group,'kernel_function','rbf')
    cellSVM=svmtrain([back;fore],group,'kernel_function','polynomial','polyorder',2,'showplot','True');

    [m n k]=size(im2);
    im_new=double(reshape(im2,m*n,k));
    imcla=svmclassify(cellSVM,im_new);
    imcla=~imcla;
    res=reshape([imcla],[m,n]);
    im_new2=im2;
    im_new2(res)=1;
    im_new2=imcomplement(im_new2);

    bw_svm=im2bw(im_new2,0);
    CC=bwconncomp(bw_svm);
    s=regionprops(CC,'Area','Perimeter');
    idx_svm=find([s.Area]<100);
    bw_svmS=ismember(labelmatrix(CC),idx_svm);

    bw_svm(bw_svmS)=0;
    bw_svm=imfill(bw_svm,4,'holes');
    % bw2=imopen(bw,strel('disk',5));



    D=-bwdist(~bw_svm);
    % D(~bw_svm)=Inf;
    L=watershed(D,8);
    bw_svm_seg=bw_svm;
    bw_svm_seg(L==0)=0;
    mask=imextendedmin(D,2);
    % imshowpair(bw_svm,mask,'blend')
    D2=imimposemin(D,mask);
    L2=watershed(D2);
    bw3=bw_svm;
    bw3(L2==0)=0;
    CC3=bwconncomp(bw3);
    s3=regionprops(CC3,'Centroid');

    [lab,num]=bwlabel(bw3);

    bounds=bwboundaries(bw3);%boundary of connected components

    figure(1);
    imagesc(im2);
   
    %title('segment with gaussian filter');
%     brighten(0.3)
    hold on
    for i=1:length(bounds)
%         drawnow
        q=plot(bounds{i}(:,2),bounds{i}(:,1),'-r');
%         str={i};
%         text(s3(i).Centroid(1),s3(i).Centroid ),str,'Color','red');
        set(q,'Linewidth',1);
%         f=getframe;
%         f=frame2im(f);
%         [A,map]=rgb2ind(f,256);
    %     if i==length(bounds)
    %         imwrite(A,map,path,'WriteMode','Append');
    %     end
    %         else
    %             imwrite(A,map,'/Users/wangxinyi/Desktop/CTIA/project/data/root3 label1.gif','WriteMode','Append');
    %         end
%         if mod(i,10)==1
%             if i==1
%                 imwrite(A,map,'/Users/wangxinyi/Desktop/CTIA/project/data/root1 count.gif');
%             else
%                 imwrite(A,map,'/Users/wangxinyi/Desktop/CTIA/project/data/root1 count.gif','WriteMode','Append');
%             end
%         end
%         if i>100
%             imwrite(A,map,'/Users/wangxinyi/Desktop/CTIA/project/data/root1 count.gif','WriteMode','Append');
%         end
    end
    % imwrite(A,map,path,'WriteMode','append');
%     saveas(gcf,name)

end
close(obj);

% figure(1);
% imshow(im2,[]);
% figure(2);
% imshow(label2rgb(L),[]);
% 
% figure(3);
% imshow(bw_svm,[]);

%% 
% se = strel('disk',1,8);
% %im_max = imdilate(im_med,se);
% im_min = imerode(im1,se);
% im_max = imdilate(im_min,se);
% 
% % top_bottom hat transformation
% % im_top=imtophat(im2,se);
% % im_bot=imbothat(im2,se);
% % Ienhance = imsubtract(imadd(im_top, im2), im_bot);
% % Iec = imcomplement(Ienhance);
% % Iemin = imextendedmin(Iec, 0.5);
% % Iimpose = imimposemin(Iec, Iemin);
% 
% 
% 
% [gm,gd]=imgradient(im1);
% [gmm,gdm]=imgradient(im_new2);
% figure(1);
% imagesc(im2);
% colormap gray;
% title('original');
% 
% figure(2);
% imagesc(im_med);
% colormap gray;
% title('sobel');
% 
% figure(3);
% imagesc(im_max);
% colormap gray;
% title('max min');
% 
% figure(4);
% imagesc(gmm);
% colormap gray;
% 
% close(obj);
