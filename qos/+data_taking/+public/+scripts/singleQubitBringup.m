% bring up qubits one by one
% Yulin Wu, 2017/3/11
%%
addpath('D:\QOS1.1\qos\dlls');
import data_taking.public.util.allQNames
import data_taking.public.util.setZDC
import data_taking.public.util.readoutFreqDiagram
import sqc.util.getQSettings
import sqc.util.setQSettings
import data_taking.public.xmon.*
% padLength = 2e3;
% com.qos.waveform.Waveform.setPadLength(padLength);
app.RE
%%
% qes.util.copySession([],'s170626');
% sqc.util.resetQSettings();
%%
qNames = allQNames();
% readoutFreqs = getQSettings('r_fr');
%%
% setQSettings('r_uSrcPower',22);
% setQSettings('r_ln',3000);
% setQSettings('r_amp',3e4);
% setQSettings('r_wvSettings.ring_amp',0);
% setQSettings('r_wvSettings.ring_w',150);
% setQSettings('qr_xy_uSrcPower',20);
%% just in case the hardware dose not startup with zero dc output, we set the output of qubit dc channels to zero
% setQSettings('zdc_amp',0);
qNames = allQNames();
for ii = 1:numel(qNames)
    % set to the dc value in registry:
	setZDC(qNames{ii});
    % or set to an specifice value
    % setZDC(qNames{ii},0);
end
%% s21 vs power with network analyzer
for qubitIndex = 1:9
data_taking.public.s21_scan_networkAnalyzer(... % 'NAName' can be ommitted if there is only one network analyzer
      'startFreq',readoutFreqs(qubitIndex)-0.5e6,'stopFreq',readoutFreqs(qubitIndex)+2e6,...
      'numFreqPts',501,'avgcounts',30,...
      'NAPower',[-30:1:20],'bandwidth',30e3,...
      'notes','attenuation:30dB','gui',true,'save',true);
end
%% s21 vs qubit dc bias with network analyzer
for qubitIndex = 1:9
s21_zdc_networkAnalyzer('qubit',qNames{qubitIndex},...% 'NAName' can be ommitted if there is only one network analyzer
      'startFreq',readoutFreqs(qubitIndex)-0.1e6,'stopFreq',readoutFreqs(qubitIndex)+1e6,...
      'numFreqPts',51,'avgcounts',20,'NApower',-10,...
      'biasAmp',[-3.2e4:200:3.2e4],'bandwidth',30e3,...
      'gui',true,'save',true);
end
%% s21 with DAC, a coarse scan to find all the qubit readoutFreqs
amp = 3.7e3; % logspace(log10(1000),log10(32768),20);
freq = 6.8815e9-2e6:0.1e6:6.8815e9+2e6;
s21_rAmp('qubit',qNames{8},'freq',freq,'amp',amp,...
      'notes','attenuation:20dB','gui',true,'save',true);
%% finds all qubit readoutFreqs automatically by fine s21 scan, session/public/autoConfig.readoutResonators.* has to be properly set for it to work
[readoutFreqs, pkWithd] = auto.qubitreadoutFreqs();
% after this you need to order readoutFreqs in accordance with qNames
% the upadate the readoutFreqs value to r_fr in registry for each qubit:
%% if all readoutFreqs are found correctly, save them to r_fr and r_freq in registry for each qubit:
readoutFreqs = [6.5922000,6.6331600,6.6773200,6.7239600,6.761480,6.798480,6.839720,6.881200,6.9242400]*1e9;
%%
for ii = 1:numel(qNames)
    % r_fr, the qubit dip frequency, it's exact value changes with qubit state and readout power,
    % the value of r_fr is just a reference frequency for automatic
    % routines, a close value is sufficient.
    setQSettings('r_fr',readoutFreqs(ii),qNames{ii});
    % also set r_freq is the frequency of the readout pulse, it is slightly
    % different than the qubit dip frequency after optimization, but at the beginning of the
    % meausrement, set it to the qubit dip frequency is OK.
    setQSettings('r_freq',readoutFreqs(ii),qNames{ii});
end
%%  s21 vs power with DAC to finds the dispersive shift
amp = logspace(log10(1000),log10(32768),20);
amp = 2.5e3;
rfreq = getQSettings('r_freq',q);
freq = rfreq-1.5e6:0.1e6:rfreq+1e6;
s21_rAmp('qubit',qNames{8},'freq',freq,'amp',amp,...
      'notes','','gui',true,'save',true);
%%
s21_zdc('qubit', qNames{4},...
      'freq',[6.7986e9-1.5e6:0.1e6:6.7986+1e6],'amp',[-3e4:1.5e3:3e4],...
      'gui',true,'save',true);
%%
s21_zpa('qubit', 'q4',...
      'freq',[readoutFreqs(4)-2.2e6:0.15e6:readoutFreqs(4)+1e6],'amp',[-3e4:2e3:3e4],...
      'gui',true,'save',true); 
%% 
f01 = getQSettings('f01',q);
freq = f01-5e6:0.2e6:f01+5e6;
spectroscopy1_zpa('qubit',q,'biasAmp',[0:2000:2e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);  % dataTyp: S21 or P
% spectroscopy1_zpa('qubit','q2'); % lazy mode
%%
spectroscopy1_power('qubit','q6',...
       'biasAmp',0,'driveFreq',[4.75e9:0.2e6:5.4e9],...
       'uSrcPower',[5:1:20],...
       'dataTyp','P','gui',true,'save',true); % dataTyp: S21 or P
%%
spectroscopy111_zpa('biasQubit','q9','biasAmp',[-5000:1000:5000],...
       'driveQubit','q8','driveFreq',[],...
       'readoutQubit','q8''dataTyp','P',...
       'notes','q9->q8 zpls cross talk','gui',true,'save',true);
%%
f01 = getQSettings('f01',q);
freq = f01-10e6:0.5e6:f01+3e6;
spectroscopy1_zdc('qubit',q,'biasAmp',[-0e4:200:0.4e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true); % dataTyp: S21 or P
%%
% q7zAmp2f01 =@(x) - 0.46539*x.^2 + 2709.5*x + 5.222e+09;
% q8zAmp2f01 =@(x) - 0.2994*x.^2 + 1890.6*x + 4.7344e+09;
% q9_1zAmp2f01 = @(x) - 0.727*x.^2 - 1.83e+04*x + 5.02e+09;
q9_zpa2f01 = @(x) - 0.55133*x.^2 + 188.64*x + 5.175e+09;
q9_zpa2f02 = @(x) - 0.55133*x.^2 + 188.64*x + 5.175e+09 - 119e6;
q8_zpa2f01 = @(x) - 0.401*x.^2 + 31.43*x + 4.736e+09;
q6_zpa2f01_s = @(x) (- 1.6e-05*x + 4.5747)*1e9;
spectroscopy1_zpa_bndSwp('qubit','q9',...
       'swpBandCenterFcn',q6_zpa2f01_s,'swpBandWdth',20e6,...
       'biasAmp',[-5000:500:32000],'driveFreq',[4.65e9:0.2e6:5.2e9],...
       'gui',true,'save',true);
% spectroscopy1_zpa_bndSwp('qubit','q2',...
%        'swpBandCenterFcn',q2zAmp2f01,'swpBandWdth',120e6,...
%        'biasAmp',[6000:50:9750],'driveFreq',[5.56e9:0.2e6:5.77e9],...
%        'gui',false,'save',true);
%%
rabi_amp1('qubit','q8','biasAmp',[0],'biasLonger',20,...
      'xyDriveAmp',[0:500:3e4],'detuning',[0],'driveTyp','X',...
      'dataTyp','S21','gui',true,'save',true);
% rabi_amp1('qubit','q2','xyDriveAmp',[0:500:3e4]);  % lazy mode
%%
rabi_long1_amp('qubit','q6','biasAmp',0,'biasLonger',5,...
      'xyDriveAmp',[1000:5000:2e4],'xyDriveLength',[1:4:2000],...
      'dataTyp','P','gui',true,'save',true);
%%
rabi_long1_freq('qubit','q6','biasAmp',0,'biasLonger',5,...
      'xyDriveAmp',8000,'xyDriveLength',[1:4:2000],...
      'detuning',[-10:1:10]*1e6,...
      'dataTyp','P','gui',true,'save',true);
%%
rabi_long1('qubit','q6','biasAmp',0,'biasLonger',5,...
      'xyDriveAmp',[1000:200:30000],'xyDriveLength',[1:2:200],...
      'dataTyp','P','gui',true,'save',true);
%%
s21_01('qubit',q,'freq',[],'notes','','gui',true,'save',true);
%%
ramsey('qubit','q9','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:2e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
%%
ramsey('qubit','q9','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:6:0.5e3],'detuning',[5]*1e6,...
      'dataTyp','Phase','phaseOffset',0,'notes','','gui',true,'save',true);
%%
spin_echo('qubit','q8_7k','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:20e3],'detuning',[5]*1e6,...
      'notes','','gui',true,'save',true);
%%
T1_1('qubit','q8_7k','biasAmp',[0],'biasDelay',20,'time',[0:100:29e3],...
      'gui',true,'save',true);
%%
resonatorT1('qubit','q2',...
      'swpPiAmp',1.8e3,'biasDelay',16,'swpPiLn',28,'time',[0:10:2000],...
      'gui',true,'save',true)
%%
tuneup.APE('qubit','q2',...
      'phase',-pi:pi/15:pi,'numI',3,...
      'gui',true,'save',true);
%%
photonNumberCal('qubit','q1',...
'time',[-500:100:2.5e3],'detuning',[0:1e6:25e6],...
'r_amp',2500,'r_ln',[],...
'ring_amp',5000,'ring_w',200,...
'gui',true,'save',true);
%%
zDelay('qubit','q7','zAmp',2000,'zLn',[],'zDelay',[-50:1:50],...
       'gui',true,'save',true)
%%
% delayTime = [[0:1:20],[21:2:50],[51:5:100],[101:10:500],[501:50:3000]];
delayTime = [-300:10:2e3];
zPulseRipple('qubit','q9_1k',...
        'delayTime',delayTime,...
       'zAmp',4e3,'gui',true,'save',true);
%%
    s = struct();
    s.type = 'function';
    s.funcName = 'qes.waveform.xfrFunc.gaussianExp';
    s.bandWidht = 0.25;
    s.r = [0.0155];
    s.td = [800];

    xfrFunc = qes.util.xfrFuncBuilder(s);
    xfrFunc_inv = xfrFunc.inv();
    xfrFunc_lp = com.qos.waveform.XfrFuncFastGaussianFilter(0.13);
    xfrFunc_f = xfrFunc_lp.add(xfrFunc_inv);

%     fi = fftshift(qes.util.fftFreq(6000,1));
%     fsamples = xfrFunc_inv.eval(fi);
%     figure();
%     plot(fi, fsamples(1:2:end),'-r');
%     fsamples = xfrFunc_f.eval(fi);
%     hold on; plot(fi, fsamples(1:2:end),'-b');

delayTime = [0:1:1.5e3];
zPulseRipplePhase_beta('qubit','q9_1k','delayTime',delayTime,...
       'xfrFunc',[xfrFunc_f],'zAmp',20e3,'s',s,...
       'notes','no xfrFunc','gui',true,'save',true);
%%
state = '|0>-i|1>';
data = singleQStateTomo('qubit','q2','reps',2,'state',state);
rho = sqc.qfcns.stateTomoData2Rho(data);
h = figure();bar3(real(rho));h = figure();bar3(imag(rho));
%%
gate = 'Y/2';
data = singleQProcessTomo('qubit','q2','reps',2,'process',gate);
chi = sqc.qfcns.processTomoData2Rho(data);
h = figure();bar3(real(chi));h = figure();bar3(imag(chi));
%% single qubit gate benchmarking
setQSettings('r_avg',200);
numGates = 1:1:5;
[Pref,Pi] = randBenchMarking('qubit1','q7','qubit2',[],...
       'process','-X/2','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);

%% two qubit gate benchmarking
setQSettings('r_avg',250);
numGates = 1:1:10;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8_7k',...
       'process','CZ','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);
%%
q = 'q9';

tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save','askMe');
tuneup.optReadoutFreq('qubit',q,'gui',true,'save','askMe');
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save','askMe');

tuneup.correctf01bySpc('qubit',q,'gui',true,'save','askMe'); % measure f01 by spectrum
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',true,'gui',true,'save','askMe');
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save','askMe');
%% fully auto callibration
% qubits = {'q7','q8'};
qubits = {'q9','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2','X/4'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    end
end
%%
setQSettings('r_avg',1000,'q8_7k');
setQSettings('r_avg',1000,'q9');
acz_ramsey('controlQ','q9','targetQ','q8_7k',...
       'czLength',[70:4:150],'czAmp',[2.1e4:200:2.45e4],'czDelay',20,'cState','1',...
       'notes','','gui',true,'save',true);
%%
setQSettings('r_avg',1000,'q8');
setQSettings('r_avg',1000,'q9');
acz_ampLength('controlQ','q9','targetQ','q8',...
       'dataTyp','Phase',...
       'czLength',[60:2:200],'czAmp',[2.1e4:100:2.9e4],'cState','1',...
       'notes','','gui',true,'save',true);

%%
qqSwap('qubit1','q7','qubit2','q8',...
       'biasQubit',1,'biasAmp',[-1.7e4:-100:-2.5e4],'biasDelay',10,...
       'q1XYGate','X','q2XYGate','X',...
       'swapTime',[0:10:100],'readoutQubit',2,...
       'notes','','gui',true,'save',true);
%%
setQSettings('r_avg',2000,'q8');
setQSettings('r_avg',2000,'q9');
CZTomoData = Tomo_2QProcess('qubit1','q9','qubit2','q8',...
       'process','CZ','reps',1,...
       'notes','','gui',true,'save',true);
%%
twoQStateTomoData = Tomo_2QState('qubit1','q7','qubit2','q8',...
  'state','|11>','reps',1,...
 'notes','','gui',true,'save',true);

