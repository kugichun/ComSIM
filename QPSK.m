% This program simulates the bit-error-rate (BER) performance of QPSK
x_q=[1 1 -1 -1]; %實部
y_q=[1 -1 1 -1]; %虛部

QPSK_s=x_q+y_q*i;

Es=1; %average constellation energy for d=2;

index=1;

BER=zeros(1,10);

for SNR=2:2:20
%number of bit errors set to zero
count=0;

%number of iterations迭代
N=10000;
for it=1:N
%generate 8 bits uniformly distributed
A=round(rand(1,8));
% TX symbols
% QPSK
s1=QPSK_s(bi2de(A(1:2),'left-msb')+1); %left-msb:從左到右看
s2=QPSK_s(bi2de(A(3:4),'left-msb')+1);
s3=QPSK_s(bi2de(A(5:6),'left-msb')+1);
s4=QPSK_s(bi2de(A(7:8),'left-msb')+1);
C=[s1 s2 s3 s4];

%AWGN channel
N0=Es/10^(SNR/10);
Z=sqrt(N0/2)*(randn(1,4)+i*randn(1,4)); % variance N0

%RX symbols
R=C+Z;

%ML decoding
%find for S1 corresponding bits
[H1,I]=min(QPSK_s-R(1));
dec_bits(1,1:2)=de2bi(I(1)-1,2,'left-msb');

%find for S2 corresponding bits
[H1,I]=min(QPSK_s-R(2));
dec_bits(1,3:4)=de2bi(I(1)-1,2,'left-msb');

%find for S3 corresponding bits
[H1,I]=min(QPSK_s-R(3));
dec_bits(1,5:6)=de2bi(I(1)-1,2,'left-msb');

%find for S4 corresponding bits
[H1,I]=min(QPSK_s-R(4));
dec_bits(1,7:8)=de2bi(I(1)-1,2,'left-msb');

%count errors
count=count+sum(abs(A-dec_bits));

end;
BER(index)=count/(N*8)
index=index+1;
end;
figure(100)
SNR=2:2:20;
semilogy(SNR,BER)
xlabel('SNR(dB)')
ylabel('BER')
grid
title('BER Performance of the QPSK')