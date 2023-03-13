% Experiment_2-4 DFT matrix
clc;
x="Input the matrix dimention : "; 
N=input(x); %輸入DFT維度
w=exp(-2i*pi/N); %公式帶入

y=w.^[0:N-1]; %做等比級數，公差為w

dft = fliplr(vander(y)); %做 Vandermonde 矩陣
disp(dft);