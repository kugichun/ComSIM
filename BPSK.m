clc
clear all;

f = 1;        %sin函數頻率
fs = 100;     %取樣頻率
t = 0:1/fs:1; %時間間隔
snr=15;       %訊雜比
df_T=0.3;

%設定BPSK相位差 
p1 = 0;
p2 = pi;

%設定位元數
N = 10;

%生成隨機訊號
bit_sequence=round(rand(1,N));

%創建容器
time = [];
digital_signal = [];
PSK = [];
carrier_signal = [];

%產生位元序列
for ii = 1:1:N %1:10

    if bit_sequence(ii) == 0
        bit = zeros(1,length(t));
    else
        bit = ones(1,length(t));
    end
    digital_signal = [digital_signal bit];
    
    %產生BPSK訊號
    if bit_sequence(ii) == 0
        bit = sin(2*pi*f*t+p1);
    else
        bit = sin(2*pi*f*t+p2);
    end
    PSK = [PSK bit];
    
    %生成載波
    carrier = sin(2*pi*f*t); % f=1 % t=0:1/fs:1
    carrier_signal = [carrier_signal carrier];
    time = [time t]; %時間間隔 1/fs =0.01
    t = t + 1;
end

%加入AWGN Noise
PSK_AWGN=awgn(PSK,snr);

%Channel fading coefficients
K=exp(-j*2*pi*df_T);
PSK_off=PSK*K;

%頻偏後加入AWGN Noise
PSK_offset=awgn(PSK_off,snr);

%計算理想BER
BER_BPSK=1/2*erfc(sqrt(snr)); %補誤差函數

% 計算加入雜訊之BER
BER_BPSK_AWGN=abs(PSK_AWGN-PSK)/abs(PSK);

% 計算頻偏後加入雜訊之BER
BER_BPSK_offset=abs(PSK_offset-PSK)/abs(PSK);


%繪圖
subplot(5,1,1);
plot(time,PSK,'r','linewidth',2);
title({'理想 BPSK 調變訊號',['BER=',num2str(BER_BPSK)]})
grid on;
axis tight;

subplot(5,1,2);
plot(time,PSK_AWGN,'r','linewidth',2);
title({'BPSK+AWGN 調變訊號',['BER=',num2str(BER_BPSK_AWGN)]})
grid on;
axis tight;

subplot(5,1,3);
plot(time,PSK_offset,'r','linewidth',2);
title({'頻偏之 BPSK+AWGN 調變訊號',['BER=',num2str(BER_BPSK_offset)]})
grid on;
axis tight;

subplot(5,1,4);
plot(time,digital_signal,'linewidth',2);% linewidth:調整線條粗度
title('位元序列')
grid on;
axis([0 time(end) -0.5 1.5]);

subplot(5,1,5);
plot(time,carrier_signal,'linewidth',2);
title('載波訊號')
grid on;
axis tight;