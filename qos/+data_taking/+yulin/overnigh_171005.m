s = struct();
s.type = 'function';
s.funcName = 'qes.waveform.xfrFunc.gaussianExp';
s.bandWidht = 0.25;
s.r = [0.0130];
s.td = [464];

xfrFunc = qes.util.xfrFuncBuilder(s);
xfrFunc_inv = xfrFunc.inv();
xfrFunc_lp = com.qos.waveform.XfrFuncFastGaussianFilter(0.13);
xfrFunc_f = xfrFunc_lp.add(xfrFunc_inv);
    
sqc.util.setZXfrFunc('q8',xfrFunc);
%%
qubits = {'q7','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000); 
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',2e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end

sqc.measure.gateOptimizer.czOptPhase({'q7','q8'},4,20,1500, 50);

setQSettings('r_avg',1500);
numGates = 1:1:30;
[Pref,Pi] = randBenchMarking('qubit1','q7','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);
   
qubits = {'q7','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000); 
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',2e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end

sqc.measure.gateOptimizer.czOptPhase({'q7','q8'},4,20,1500, 50);

setQSettings('r_avg',1500);
numGates = 1:1:30;
[Pref,Pi] = randBenchMarking('qubit1','q7','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);
   
%%
qubits = {'q7','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000); 
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',2e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end

setQSettings('r_avg',1000);
temp.czRBFidelityVsPlsCalParam('controlQ','q7','targetQ','q8',...
       'rAmplitude',[-0.04:0.005:0.04],'td',[100:100:1000],'calcControlQ',false,...
       'numGates',4,'numReps',20,...
       'notes','','gui',true,'save',true);

qubits = {'q7','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000); 
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',2e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end
   
setQSettings('r_avg',1000);
temp.czRBFidelityVsPlsCalParam('controlQ','q7','targetQ','q8',...
       'rAmplitude',[-0.04:0.005:0.04],'td',[100:100:1000],'calcControlQ',false,...
       'numGates',4,'numReps',20,...
       'notes','','gui',true,'save',true);
