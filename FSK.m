clc
clear all;

fs = 100;     %取樣頻率
t = 0:1/fs:1; %時間間隔
snr=15;       %訊雜比
df_T=0.3;

%設定位元數
N = 10;

%設定FSK頻率差 
f1 = 1;
f2 = 3;

%生成隨機訊號
bit_sequence=round(rand(1,N));

%創建容器
time = [];
digital_signal = [];
FSKmod = [];
carrier1_signal = [];
carrier2_signal = [];

%產生訊號
for ii = 1:1:N %1:10

    if bit_sequence(ii) == 0
        bit = zeros(1,length(t));
    else
        bit = ones(1,length(t));
    end
    digital_signal = [digital_signal bit];
    
    %產生FSK訊號
    if bit_sequence(ii) == 0
        bit = sin(2*pi*f1*t);
    elseif bit_sequence(ii) == 1
        bit = sin(2*pi*f2*t);
    end
    FSKmod = [FSKmod bit];
    
    %生成載波1
    carrier1 = sin(2*pi*f1*t); % f1=1 % t=0:1/fs:1
    carrier1_signal = [carrier1_signal carrier1];

    %生成載波2
    carrier2 = sin(2*pi*f2*t); % f2=2 % t=0:1/fs:1
    carrier2_signal = [carrier2_signal carrier2];

    time = [time t]; %時間間隔 1/fs =0.01
    t = t + 1;
end

%加入AWGN Noise
FSK_AWGN=awgn(FSKmod,snr);

%Channel fading coefficients
K=exp(-j*2*pi*df_T);
FSK_off=FSKmod*K;

%頻偏後加入AWGN Noise
FSK_offset=awgn(FSK_off,snr);

%計算理論BER
BER_FSK=1/2*erfc(sqrt(snr/2)); 

% 計算加入雜訊之BER
BER_FSK_AWGN=abs(FSK_AWGN-FSKmod)/abs(FSKmod);

% 計算頻偏後加入雜訊之BER
BER_FSK_offset=abs(FSK_offset-FSKmod)/abs(FSKmod);

%繪圖
subplot(6,1,1);
plot(time,FSKmod,'r','linewidth',2);
title({'理想 FSK 調變訊號',['BER=',num2str(BER_FSK)] })
grid on;
axis tight;

subplot(6,1,2);
plot(time,FSK_AWGN,'r','linewidth',2);
title({'FSK+AWGN 調變訊號',['BER=',num2str(BER_FSK_AWGN)] })
grid on;
axis tight;

subplot(6,1,3);
plot(time,FSK_AWGN,'r','linewidth',2);
title({'頻偏之 FSK+AWGN 調變訊號',['BER=',num2str(BER_FSK_offset)] })
grid on;
axis tight;

subplot(6,1,4);
plot(time,digital_signal,'linewidth',2);% linewidth:調整線條粗度
title('位元序列')
grid on;
axis([0 time(end) -0.5 1.5]);

subplot(6,1,5);
plot(time,carrier1_signal,'linewidth',2);
title('載波訊號1')
grid on;
axis tight;

subplot(6,1,6);
plot(time,carrier2_signal,'linewidth',2);
title('載波訊號2')
grid on;
axis tight;
