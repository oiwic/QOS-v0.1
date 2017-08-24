addpath('D:\QOS1.1\qos\dlls');
import data_taking.public.util.allQNames
import data_taking.public.util.setZDC
import data_taking.public.util.readoutFreqDiagram
import sqc.util.getQSettings
import sqc.util.setQSettings
import data_taking.public.xmon.*
padLength = 2e3;
com.qos.waveform.Waveform.setPadLength(padLength);
app.RE
%%
qNames = allQNames();
for ii = 1:numel(qNames)
	setZDC(qNames{ii});
end
%%
q = 'q6';
setQSettings('r_avg',1000,q);
%%
% amp = logspace(log10(1000),log10(32768),25);
amp = getQSettings('r_amp',q);
rfreq = getQSettings('r_freq',q);
freq = rfreq-1e6:0.05e6:rfreq+0.5e6;
s21_rAmp('qubit',q,'freq',freq,'amp',amp,...
      'gui',true,'save',true);
%%
setQSettings('spc_driveAmp',2e3);
setQSettings('spc_driveLn',8e3);
setQSettings('spc_sbFreq',2e8);
f01 = getQSettings('f01',q);
freq = f01-150e6:0.2e6:f01+10e6;
spectroscopy1_zdc('qubit',q,'biasAmp',[-1e4:1000:1e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);
%%
setQSettings('spc_driveAmp',3e2);
f01 = getQSettings('f01',q);
freq = f01-5e6:0.2e6:f01+5e6;
spectroscopy1_zpa('qubit',q,...
       'biasAmp',[0:2000:2e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true); 
%%
rabi_amp1('qubit',q,'biasAmp',[0],'biasLonger',20,...
      'xyDriveAmp',[0:500:3e4],'detuning',[0],'driveTyp','X','numPi',1,...
      'dataTyp','S21','gui',true,'save',true);
%%
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save','askMe');
%%
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',true,'gui',true,'save','askMe');
%%
tuneup.optReadoutFreq('qubit',q,'gui',true,'save','askMe');
%%
tuneup.correctf01bySpc('qubit',q,'gui',true,'save','askMe');
% tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
%%
ramsey('qubit',q,'mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:10e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
%%
rabi_long1_amp('qubit',q,'biasAmp',0,'biasLonger',5,...
      'xyDriveAmp',[1000:200:2e4],'xyDriveLength',[1:2:200],...
      'dataTyp','P','gui',true,'save',true);
  %%
  q = 'q3';
setQSettings('r_avg',500,q);
setQSettings('spc_driveAmp',3e3,q);
setQSettings('spc_driveLn',8e3,q);
setQSettings('spc_sbFreq',2e8,q);
f01 = getQSettings('f01',q);
freq = 5.17e9:0.2e6:5.235e9;
spectroscopy1_zdc('qubit',q,'biasAmp',[-0.5e4:50:0.2e4],'driveFreq',[freq],...
'dataTyp','S21','gui',true,'save',true);