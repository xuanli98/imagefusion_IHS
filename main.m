%% @author：李萱
% title：基于HIS的Image Fusion
% Algorithm : 
% 将高分辨的全色影像和低分辨率的多光谱影像进行融合处理后
% 得到多光谱影像，使融合后影像具有较高的空间分辨率，同时
% 具有较丰富的光谱信息
close all
clear
clc
%% 读入高光谱图像
I_MSS = mat2gray(im2double(imread('1-MSS.tif')));
I_MSS = I_MSS(:,:,1:3);
subplot(121)
imshow(I_MSS)
title('多光谱图像')

I_MSS = imresize(I_MSS,4);    % LMS上采样4倍
R = I_MSS(:,:,1);
G = I_MSS(:,:,2);
B = I_MSS(:,:,3);

%% 读入全色图像
I_PAN = mat2gray(im2double(imread('1-PAN.tif')));
[ylen, xlen, c] = size(I_MSS);

%% IHS变换
% RGB ==> IHS 正变换矩阵
tran1 = [ 1/3,         1/3,         1/3;       
          -sqrt(2)/6,  -sqrt(2)/6,  sqrt(2)/3;      
          1/sqrt(2),   -1/sqrt(2),  0         ];
  
% IHS ==> RGB 逆变换矩阵
tran2 = [ 1,  -1/sqrt(2),  1/sqrt(2);       
          1,  -1/sqrt(2),  -1/sqrt(2);      
          1,  sqrt(2),     0           ];

trans_in = [reshape(R, 1, ylen * xlen); ...
            reshape(G, 1, ylen * xlen); ...
            reshape(B, 1, ylen * xlen)];

% 进行 RGB ==> IHS 正变换
trans_res = tran1 * trans_in;
% 利用 PAN 替换 I 分量
trans_res(1,:) = reshape(I_PAN, 1, ylen*xlen);
% 进行 IHS ==> RGB 反变换
trans_res = tran2 * trans_res;

% 把变换结果保存到 I_FUS 中
I_FUS = zeros(ylen, xlen, 3);
I_FUS(:,:,1) = reshape(trans_res(1, :), ylen, xlen);
I_FUS(:,:,2) = reshape(trans_res(2, :), ylen, xlen);
I_FUS(:,:,3) = reshape(trans_res(3, :), ylen, xlen);
subplot(122)
imshow(I_FUS)
title('融合后的图像')








