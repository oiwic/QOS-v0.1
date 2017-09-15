% bring up qubits - tuneup
% Yulin Wu, 2017/3/11
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
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    end
end
%%
setQSettings('r_avg',1000,'q8');
setQSettings('r_avg',1000,'q9');
acz_ampLength('controlQ','q9','targetQ','q8',...
       'dataTyp','Phase',...
       'czLength',[200],'czAmp',[1.8e4-2000:100:1.8e4+2000],'cState','0',...
       'notes','','gui',true,'save',true);
%%
setQSettings('r_avg',1000,'q8');
setQSettings('r_avg',1000,'q9');
acz_ampLength('controlQ','q9','targetQ','q8',...
       'dataTyp','Phase',...
       'czLength',[200],'czAmp',[1.8e4-2000:100:1.8e4+2000],'cState','1',...
       'notes','','gui',true,'save',true);
%%
tuneup.APE('qubit','q8',...
      'phase',-pi:pi/40:pi,'numI',4,...
      'gui',true,'save',true);
%%
tuneup.DRAGAlphaAPE('qubit','q8','alpha',[1.1:0.02:2.2],...
    'phase',0,'numI',10,...
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
temp.czRBFidelityVsPhase('controlQ','q9','targetQ','q8',...
      'phase_c',[-pi:pi/20:pi],'phase_t',[-pi:pi/20:pi],'czAmp',2.662e4,...
      'numGates',2,'numReps',70,...
      'notes','','gui',true,'save',true);
%%
qubits = {'q9','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end

setQSettings('r_avg',800,'q8');
setQSettings('r_avg',800,'q9');
temp.czRBFidelityVsPhase('controlQ','q9','targetQ','q8',...
      'phase_c',[-pi:2*pi/25:pi],'phase_t',[-pi:pi/25:pi],'czAmp',2.662e4,...
      'numGates',3,'numReps',50,...
      'notes','','gui',true,'save',true);
  
qubits = {'q9','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end

setQSettings('r_avg',800,'q8');
setQSettings('r_avg',800,'q9');
temp.czRBFidelityVsPhase('controlQ','q9','targetQ','q8',...
      'phase_c',[-pi:2*pi/20:pi],'phase_t',[-pi:2*pi/20:pi],'czAmp',26858,...
      'numGates',2,'numReps',50,...
      'notes','','gui',true,'save',true);
%%
qubits = {'q9','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end
%%
setQSettings('r_avg',1000,'q8');
setQSettings('r_avg',1000,'q9'); 
temp.czRBFidelityVsPlsCalParam('controlQ','q9','targetQ','q8',...
       'rAmplitude',[0:0.002:0.016],'td',[500:100:1200],'calcControlQ',false,...
       'numGates',4,'numReps',10,...
       'notes','','gui',true,'save',true)
   
%%
qubits = {'q9','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end

sqc.measure.gateOptimizer.czOptPulseCal_2({'q9','q8'},false,4,15,1500, 40);

setQSettings('r_avg',2000,'q8');
setQSettings('r_avg',2000,'q9');
numGates = 1:1:30;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8',...
'process','CZ','numGates',numGates,'numReps',70,...
'gui',true,'save',true);
  

