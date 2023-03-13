% Experiment_2-3 Parserval’s Theorem
clc;

x=[1 2 3 4];
X=fft(x);%驗證做完FFT後結果是否相同
N=length(x);

p1=sum(abs(x.*x));
p2=sum(abs(X.*X)/N);

str1=['The sum of Parservals Theorem before FFt is : ',num2str(p1)];
str2=['The sum of Parservals Theorem after FFt is : ',num2str(p2)];

disp(str1);
disp(str2);