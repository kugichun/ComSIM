% Experiment_2 Clin & Ccirc
% 驗證線性卷積的長度
% 驗證循環卷積與線性卷積之等效條件，在進行DFT 之前，必須用零填充向量
% 使長度至少為N + L - 1。對DFT 的積求逆轉換後，只保留前N + L - 1 個元素。

clear;

x = [5 6 8 2 5]; %L=5
y = [6 -1 3 5 1]; %M=5

 %Linear Convolution
clin = conv(x,y,'full');  
str=['The length of Linear Convolution is : ',num2str(length(clin))];% 驗證線性卷積的長度，
disp(str); % length=L+M-1

 %Circular Convolution
 %由於輸出長度為L+M-1=9，需用 0 填充 x,y 兩個向量，把長度都補滿9
xpad = [x zeros(1,9-length(x))];
ypad = [y zeros(1,9-length(y))];
ccirc = ifft(fft(xpad).*fft(ypad)); % Circular Convolution公式

%繪製線性卷積
subplot(2,1,1) %2列1行之區域1
stem(clin, 'filled' )
ylim([0 100]) % ylim:設置y 坐標軸範圍
title( 'Linear Convolution of x and y' )

%繪製循環卷積
subplot(2,1,2) %2列1行之區域2
stem(ccirc, 'filled' )
ylim([0 100])
title( 'Circular Convolution of xpad and ypad' )

%填零後的向量 xpad 和 ypad 的循環卷積等效於 x 和 y 的線性卷積。
%因為輸出長度皆為4+3-1，並保留了循環卷積所有元素。