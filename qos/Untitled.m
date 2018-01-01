length = 200;
amplitude = 1;
thf = 0.864;
thi = 0.05;
lam2 = -0.18;
lam3 = 0.04;
figure();
for thf = linspace(0.7*0.864,1.3*0.864,6)
% for thi = linspace(0.7*0.05,1.3*0.05,6)
% for lam2 = linspace(-0.7*0.18,-1.3*0.18,6)
% for lam3 = linspace(0.3*0.04,2*0.04,6)
wv = qes.waveform.acz(length, amplitude, thf, thi, lam2, lam3);
seq = qes.waveform.sequence(wv);
daSeq = qes.waveform.DASequence(1,seq);
samples = daSeq.samples();
hold on; plot(samples(1,:));
end