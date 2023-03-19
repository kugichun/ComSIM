clear all;
clc;

SNR_dB=1:20;
snr=10.^(SNR_dB/10);
N=100000;
df_T=0.1;
A=randi([0,1],1,N);
[row,column] = size(A);

y=[];
for it=1:row
    p=1;
    for t = 1:2:column
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TX symbols
% matlab  ind 從1開始
% QPSK，使用Gray Code

    if A(1,t)==0 && A(1,t+1)==0
         y(1,p)=-1-1i;

    elseif A(1,t)==0 && A(1,t+1)==1
         y(1,p)=-1+1i;

    elseif A(1,t)==1 && A(1,t+1)==0
         y(1,p)=1-1i;
    else
         y(1,p)=1+1i;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % TX symbols
% % matlab  ind 從1開始
% % QPSK，不使用Gray Code
% 
%     if A(1,t)==0 && A(1,t+1)==0
%          y(1,p)=1+1i;
% 
%     elseif A(1,t)==0 && A(1,t+1)==1
%          y(1,p)=-1-1i;
% 
%     elseif A(1,t)==1 && A(1,t+1)==0
%          y(1,p)=-1-1i;
%     else
%          y(1,p)=-1+1i;
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    p=p+1;
    end
end
%Channel fading coefficients
K=exp(-j*2*pi*df_T);

%產生雜訊
for count=1:length(SNR_dB)
    N0=1/2/snr(count);
    N0_dB=10*log10(N0);

    Real_Z=sqrt(N0)*randn(1,N/2);
    Img_Z=sqrt(N0)*randn(1,N/2);
    ys=(real(y)+Real_Z)+1i*(imag(y)+Img_Z);
    ys_off=(real(y)*K+Real_Z)+1i*(imag(y)*K+Img_Z);

 %  以下為嘗試項目
 %  ni=wgn(1,N/2,N0_dB);
 %  ys=awgn(y,N0_dB);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RX symbols
% QPSK轉回序列(無頻偏)
    [n,m] = size(ys);
    q1=[];
    q2=[];
    for b=1:n
        j=1;

        for d=1:m
            if real(ys(b,d))<0 && imag(ys(b,d))<0
                q1(b,j)=0;
                q1(b,j+1)=0;
            elseif real(ys(b,d))<0 && imag(ys(b,d))>0
                q1(b,j)=0;
                q1(b,j+1)=1;
            elseif real(ys(b,d))>0 && imag(ys(b,d))<0
                q1(b,j)=1;
                q1(b,j+1)=0;
            elseif real(ys(b,d))>0 && imag(ys(b,d))>0
                q1(b,j)=1;
                q1(b,j+1)=1;
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RX symbols
% QPSK轉回序列(有頻偏)
            if real(ys_off(b,d))<0 && imag(ys_off(b,d))<0
                q2(b,j)=0;
                q2(b,j+1)=0;
            elseif real(ys_off(b,d))<0 && imag(ys_off(b,d))>0
                q2(b,j)=0;
                q2(b,j+1)=1;
            elseif real(ys_off(b,d))>0 && imag(ys_off(b,d))<0
                q2(b,j)=1;
                q2(b,j+1)=0;
            elseif real(ys_off(b,d))>0 && imag(ys_off(b,d))>0
                q2(b,j)=1;
                q2(b,j+1)=1;
            end
            j=j+2;
        end
    end
    [number1,BER_AWGN(count)]=symerr(A,q1);
    [number2,BER_AWGN_off(count)]=symerr(A,q2);
    [number3,BER_Initial(count)]=symerr(A,A);

end

% BER_Initial=1/2*erfc(sqrt(snr/2));

%計算平均位元錯誤率
BER_avg_I=sum(BER_Initial)/count;
BER_avg_N=sum(BER_AWGN)/count;
BER_avg_O=sum(BER_AWGN_off)/count;

%繪製理論之QPSK
scatterplot(y);
title({'QPSK Initial',['Average BER : ',num2str(BER_avg_I)] });
grid on;
axis tight;

%繪製加入AWGN之QPSK
scatterplot(ys);
title({'QPSK AWGN',['Average BER : ',num2str(BER_avg_N)] });
grid on;
axis tight;

%繪製頻偏且加入AWGN之QPSK
scatterplot(ys_off);
title({'QPSK AWGN',['Average BER : ',num2str(BER_avg_O)] });
grid on;
axis tight;

%繪圖
figure;
semilogy(SNR_dB,BER_AWGN,'-b','LineWidth',2);hold on;
semilogy(SNR_dB,BER_AWGN_off,'-r','LineWidth',2);hold on;
legend('QPSK+AWGN','頻偏QPSK+AWGN');
axis([-1,10,10^-4,1]);
title('BER Performance of the QPSK');
xlabel('SNR(dB)');
ylabel('BER');
