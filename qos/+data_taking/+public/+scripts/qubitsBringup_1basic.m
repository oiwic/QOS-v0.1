% bring up qubits
% Yulin Wu, 2017/3/11
%%
cd('D:\QOSv1.1\qos');
rmpath(genpath('D:\QOS\qos'));
addpath('D:\QOSv1.1\qos\dlls');
import data_taking.public.util.allQNames
import data_taking.public.util.setZDC
import data_taking.public.util.readoutFreqDiagram
import sqc.util.getQSettings
import sqc.util.setQSettings
import data_taking.public.xmon.*
% padLength = 2e3;
% com.qos.waveform.Waveform.setPadLength(padLength);
clc;
app.RE
%%
% qes.util.copySession([],'s170626');
% sqc.util.resetQSettings();
%%
qNames = allQNames();
% readoutFreqs = getQSettings('r_fr');
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
amp = logspace(log10(1000),log10(32768),20);
q = 'q5';
fr0 = getQSettings('r_fr',q);
freq = fr0-02e6:0.1e6:fr0+2e6;
s21_rAmp('qubit',q,'freq',freq,'amp',amp,...
      'notes','','gui',true,'save',true);
%% finds all qubit readoutFreqs automatically by fine s21 scan, session/public/autoConfig.readoutResonators.* has to be properly set for it to work
[readoutFreqs, pkWithd] = auto.qubitreadoutFreqs();
% after this you need to order readoutFreqs in accordance with qNames
% the upadate the readoutFreqs value to r_fr in registry for each qubit:
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
s21_01('qubit',q,'freq',[],'notes','','gui',true,'save',true);
%% hint: you can use this to measure IQ stability over a long duration of time
IQvsReadoutDelay('qubit','q9','delay',[0:1:32],...
    'notes','','gui',true,'save',true);

