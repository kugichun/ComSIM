% Experiment_1-2 Autocorrelation Calculation
clear;
Nzc=997;
q=Nzc/31;%32.16
q1=floor(q+0.5); %32

%生成ZC序列
for m = 1:Nzc
    zc1(m)=exp(-j*pi*q1*m*(m+1)/Nzc); % 4G PSS
end

%做位移自相關，測試linear shift
for m = 1:Nzc 

    zc1_zero=[zeros(1,m-1) zc1(1:end-m+1)]; %位移補零

    cor_zc1(m)=sum(zc1.*conj(zc1_zero))/Nzc;
end

t=1:997;
plot(t,abs(cor_zc1),'b'); % abs() %求绝对值





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Experiment_1 Autocorrelation Calculation
% clear;
% Nzc=997;
% q=Nzc/31;%32.16
% q1=floor(q+0.5); %32
% 
% %生成ZC序列
% for m = 1:Nzc
%     zc1(m)=exp(-j*pi*q1*m*(m+1)/Nzc);%4G PSS
% end
% 
% %做初始自相關
% cor_zc1(1)=sum(zc1.*conj(zc1))/Nzc;  %conj(zc1):返回zc1的複共軛;  [.*]:按元素乘法;  sum():數組元素總和
% 
% %做位移自相關，circular shift
% for m = 2:Nzc 
%     zc1_round=[zc1(m:end) zc1(1:m-1)];
%     cor_zc1(m)=sum(zc1.*conj(zc1_round))/Nzc;
% end
% 
% t=1:997;
% plot(t,abs(cor_zc1),'b'); % abs() %求绝对值
