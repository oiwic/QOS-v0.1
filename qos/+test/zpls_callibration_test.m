load('D:\data\20170721\stepResponse_fs25G.mat');

fs_da = 2e9;
fs_osc = 25e9/fs_da;
t = (0:length(stepResponse_fs25G)-1)/fs_osc;
impr = qes.util.derivative(t,stepResponse_fs25G);
figure();plot(t,impr);

IMPR_fa = fftshift(fft(impr));
IMPR_f = fftshift(qes.util.fftFreq(numel(t),fs_osc));
% IMPR_fa = exp(2j*pi*IMPR_f*25.545).*IMPR_fa;
IMPR_fa = exp(2j*pi*IMPR_f*4.67).*IMPR_fa;
ind = abs(IMPR_f)>0.55;
IMPR_f(ind) = [];
IMPR_fa(ind) = [];
            figure();plot(IMPR_f,real(IMPR_fa));
                IMPR_fa = IMPR_fa./sinc(IMPR_f);
            hold on;plot(IMPR_f,real(IMPR_fa));
%%

%%
td1=360e-9;td2=10e-9;amp1=1;amp2=0.007;fs = 2e9;

t = 0:0.1/fs:10*td2;

a1 = amp1*exp(-t/td1);
a2 = amp2*exp(-t/td2);
v = 1-a1-a2;
impr = qes.util.derivative(t,v);

            figure();plot(t,impr);
IMPR_fa = fftshift(fft([impr,zeros(1,1000)]));
            figure();plot(real(IMPR_fa));