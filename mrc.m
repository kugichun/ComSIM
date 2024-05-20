% theroritical MRC equalizer
close all; clear all; clc;

EbN_dB=0:2:30;
EbNo=10.^(0.1*EbN_dB);

NR = 4; % number of receive antenna

for L = 1:NR

for i=1:length(EbNo)

lamda = sqrt(EbNo(i)/(2+EbNo(i)));
minus = ((1-lamda)/2).^L;

loop = 0;
for l = 0:(L-1)
    plus = ((1+lamda)/2).^l;
    fac = (factorial(L+l-1)/(factorial(l)*factorial(L-1)));
    sum = fac * plus;
    loop = loop + sum;
end

ber_nRx(i) = minus * loop;

end

semilogy (EbN_dB,ber_nRx,'*-r','linewidth',1.0)
hold on

end

axis([0 30 10^-6 1]);
xlabel('EbNo(dB)')
ylabel('BER')
title('QPSK BER over multi-path fading channel using (Maximal Ratio Combining)');
legend('Analytical');
grid on

