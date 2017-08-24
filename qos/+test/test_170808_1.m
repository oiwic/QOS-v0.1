length = 1e4;
amp = 1.5e4;
rectWv = qes.waveform.rect(length,amp);
tSamples = rectWv.samples();
figure();plot(tSamples(1,:));

%%
s.type = 'function';
s.funcName = 'qes.waveform.xfrFunc.gaussianExp';
% s.bandWidht = 0.5e9;
% s.r = [0.01];
% s.td = [314e-9]; % 314e-9
% s.fs = 2e9;

s.bandWidht = 0.25;
s.r = [0.01];
s.td = [314e-9/0.5e-9]; % 314e-9

xfrFunc = qes.util.xfrFuncBuilder(s);
xfrFunc_inv = xfrFunc.inv();
xfrFunc_lp = com.qos.waveform.XfrFuncFastGaussianFilter(0.13);
xfrFunc_f = xfrFunc_lp.add(xfrFunc_inv);
   
    fi = fftshift(qes.util.fftFreq(6000,1));
    fsamples = xfrFunc_inv.samples_t(fi);

	figure();
    plot(fi, fsamples(1:2:end),'-r');
    fsamples = xfrFunc_f.samples_t(fi);
    hold on; plot(fi, fsamples(1:2:end),'-b');

%%
load('D:\data\20170721\stepResponse_fs25G.mat');
fs_da = 2e9;
fs_osc = 25e9/fs_da;
t = (0:length(stepResponse_fs25G)-1)/fs_osc;
impr = qes.util.derivative(t,stepResponse_fs25G);
% figure();plot(t,impr);

IMPR_fa = fftshift(fft(impr));
IMPR_f = fftshift(qes.util.fftFreq(numel(t),fs_osc));
% IMPR_fa = exp(2j*pi*IMPR_f*25.545).*IMPR_fa;
IMPR_fa = exp(2j*pi*IMPR_f*4.67).*IMPR_fa;
ind = abs(IMPR_f)>0.55;
IMPR_f(ind) = [];
IMPR_fa(ind) = [];

xfrFunc_lp = com.qos.waveform.XfrFuncFastGaussianFilter(0.13); %0.13
xfrFunc_imp = com.qos.waveform.XfrFuncNumeric(IMPR_f,real(IMPR_fa),imag(IMPR_fa));
xfrFunc_imp_iverse = xfrFunc_imp.inv();
xfrFunc_f = xfrFunc_lp.add(xfrFunc_imp_iverse);
%%
S = qes.waveform.sequence(rectWv);
S.xfrFunc = xfrFunc_f;
tSamples = S.samples();
hold on;plot(tSamples(1,:));