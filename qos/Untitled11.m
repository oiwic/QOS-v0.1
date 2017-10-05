%%
q7 = sqc.util.qName2Obj('q7');
q8 = sqc.util.qName2Obj('q8');
q9 = sqc.util.qName2Obj('q9');

I = sqc.op.physical.gate.I(q7);
X7 = sqc.op.physical.gate.X(q7);
X8 = sqc.op.physical.gate.X(q8);

process = X7;

hf = figure();
ax = axes();

% q7readoutDetuneFreq = 100e6:-1e6:-300e6;
q7readoutDetuneFreq = 5e6:-0.1e6:-5e6;

% q7readoutDetuneFreq = 2e9;

numFreqPoints = numel(q7readoutDetuneFreq);
r_freq0 = q7.r_freq;
Data = NaN(1,numFreqPoints);
for ii = 1:numFreqPoints
    q7.r_freq = r_freq0 + q7readoutDetuneFreq(ii);

    R = sqc.measure.resonatorReadout_ss(q9);
    R.swapdata = true;
    R.name = 'IQ';
    R.datafcn = @(x)mean(x);
    R.delay = process.length;
    
    allReadoutQubits = R.allReadoutQubits;
    allReadoutQubits{1}.r_freq = r_freq0 + q7readoutDetuneFreq(ii);
    
    process.Run();
    R.Run();
    
    Data(ii) = R.data;
    
    plot(ax,q7readoutDetuneFreq/1e9,abs(Data));
    xlabel('q7 readout frequence (GHz)');
    drawnow;
end