% Experiment_1-1 PN Sequence Generation

clc;clear all;
G=50; %設定PN序列長度
sd2 =[1 0 1 1 1 1 1 1 1 1 1 1 0 1 0 0 1 0];  %設定LFSP系統初始序列  
PN2=[]; %創建一個PN序列容器

for i=1:G;
    PN2=[PN2 sd2(18)];

    tmp2=xor(sd2(7),sd2(18));%利用XOR邏輯閘

    for j=1:17
        k=18-j;
        sd2(k+1)=sd2(k); %將系統往後推
    end
    sd2(1)=tmp2;
end
x2 = 1 - 2.*PN2; % Convert to bipolar.

disp(x2); 


