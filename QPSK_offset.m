clear all;
clc;

SNR_dB=1:20;                         %設定訊雜比範圍，此為dB
snr=10.^(SNR_dB/10);                 %將訊雜比從dB轉化linear去算SNR
N=100000;                            %取樣次數
df_T=0.1;
A=randi([0,1],1,N);                  %創建一個從0跟1隨機取N次的序列A
[row,column] = size(A);              %將A的行列數值分別存放 row=1,column=100000

y=[];                                %創建一個容器，等等放QPSK 
 for it=1:row                        %將序列轉換後映射至星座圖
     p=1;    
     for t = 1:2:column              % 1到100000，一次讀2個，共有50000組
        % TX symbols
        % matlab ind 從1開始
        % QPSK，使用Gray Code
        if A(1,t)==0 && A(1,t+1)==0      %若A(1,1)=0 且 A(1,2)=0
            y(1,p)=-1-1i;

        elseif A(1,t)==0 && A(1,t+1)==1  %若A(1,1)=0 且 A(1,2)=1
            y(1,p)=-1+1i;

        elseif A(1,t)==1 && A(1,t+1)==0  %若A(1,1)=1 且 A(1,2)=0
          y(1,p)=1-1i;
        
        else
          y(1,p)=1+1i;                   %若A(1,1)=1 且 A(1,2)=1
       
        end
        p=p+1;
     end                             
 end                                 


%Channel fading coefficients
    K=exp(-j*2*pi*df_T);
%產生雜訊
for count=1:length(SNR_dB)           % count = 1:20
    N0=1/2/snr(count);               % 計算SNR功率，snr=10.^(SNR_dB/10)，(symbol energy=2)
    N0_dB=10*log10(N0);              % 將linear Noise轉換為dB值
    Real_Z=sqrt(N0)*randn(1,N/2);    % 設定實部雜訊
    Img_Z=sqrt(N0)*randn(1,N/2);     % 設定虛部雜訊
    ys=(real(y)*K+Real_Z)+1i*(imag(y)*K+Img_Z); % 訊息*通道衰減+雜訊
    
    % RX symbols 
    %QPSK轉回序列
    [n,m] = size(ys);                  %將ys的行列數值分別存放 n=1,m=50000(2個bits一組)
    q=[];                              %創建一個容器，等等解回之序列 
    for b=1:n            % 1:1         % 利用循環條件式解回序列（將4個星座點位置輸出為01序列）
        j=1;
                                     %利用星座點象限位置判定01序列
    for d=1:m          % 1:50000  
        if real(ys(b,d))<0 && imag(ys(b,d))<0 % real():取實部，imag():取虛部
            q(b,j)=0; 
            q(b,j+1)=0; 

        elseif real(ys(b,d))<0 && imag(ys(b,d))>0
            q(b,j)=0; 
            q(b,j+1)=1;

        elseif  real(ys(b,d))>0 && imag(ys(b,d))<0
            q(b,j)=1; 
            q(b,j+1)=0;

        elseif real(ys(b,d))>0 && imag(ys(b,d))>0
            q(b,j)=1; 
            q(b,j+1)=1;

        end
        j=j+2; %2個一組進行判定，所以完成一次判定後往後推2格(新的一組)
    end
  end                               

  [number1,BER_AWGN(count)] = symerr(A,q);  % BER_AWGN:加入AWGN之QPSK之BER
                                            % 計算BER_AWGN，公式如下
                                            % symerr(X,Y) = abs(X-Y)/abs(Y)
end

 BER_Initial=1/2*erfc(sqrt(snr/2));         %計算理論QPSK之BER

%計算平均位元錯誤率
BER_avg_I=sum(BER_Initial)/count;
BER_avg_N=sum(BER_AWGN)/count;

%繪製理論之QPSK
scatterplot(y);
title({'QPSK Initial',['Average BER : ',num2str(BER_avg_I)] });
grid on;
axis tight;
 
%繪製加入AWGN之QPSK
scatterplot(ys);
title({'QPSK AWGN',['Average BER : ',num2str(BER_avg_N)] } );
grid on;
axis tight;

%繪圖
figure;
semilogy(SNR_dB,BER_AWGN,'-b');hold on;
semilogy(SNR_dB,BER_Initial,'-g');hold on;
legend('有雜訊','無雜訊');
axis([-1,10,10^-4,1]);
title('QPSK');
xlabel('SNR(dB)');ylabel('BER');
