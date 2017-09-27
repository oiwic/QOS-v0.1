setQSettings('r_avg',2000,'q7');
setQSettings('r_avg',2000,'q8');
numGates = 1:1:30;
[Pref,Pi] = randBenchMarking('qubit1','q7','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
   
setQSettings('r_avg',10000,'q7');
setQSettings('r_avg',10000,'q8');
CZTomoData = Tomo_2QProcess('qubit1','q7','qubit2','q8',...
       'process','CZ',...
       'notes','','gui',true,'save',true);
%%
qubits = {'q7','q8'};
for ii = 1:numel(qubits)
q = qubits{ii};
setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X/2'};
for jj = 1:numel(XYGate)
tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end
end

setQSettings('r_avg',10000,'q7');
setQSettings('r_avg',10000,'q8');
CZTomoData = Tomo_2QProcess('qubit1','q7','qubit2','q8',...
       'process','CZ',...
       'notes','','gui',true,'save',true);

setQSettings('r_avg',2000,'q7');
setQSettings('r_avg',2000,'q8');
numGates = 1:1:30;
[Pref,Pi] = randBenchMarking('qubit1','q7','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
   
%%
qubits = {'q7','q8'};
for ii = 1:numel(qubits)
q = qubits{ii};
setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X/2'};
for jj = 1:numel(XYGate)
tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end
end

%%
sqc.measure.gateOptimizer.czOptPhase({'q7','q8'},4, 20,1500, 100);

qubits = {'q7','q8'};
for ii = 1:numel(qubits)
q = qubits{ii};
setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X/2'};
for jj = 1:numel(XYGate)
tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end
end

setQSettings('r_avg',10000,'q7');
setQSettings('r_avg',10000,'q8');
CZTomoData = Tomo_2QProcess('qubit1','q7','qubit2','q8',...
       'process','CZ',...
       'notes','','gui',true,'save',true);

setQSettings('r_avg',2000,'q7');
setQSettings('r_avg',2000,'q8');
numGates = 1:1:30;
[Pref,Pi] = randBenchMarking('qubit1','q7','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);



