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

setQSettings('r_avg',5000,'q8');
setQSettings('r_avg',5000,'q9');
CZTomoData = Tomo_2QProcess('qubit1','q9','qubit2','q8',...
'process','CZ','reps',1,...
'notes','','gui',true,'save',true);

setQSettings('r_avg',10000,'q8');
setQSettings('r_avg',10000,'q9');
CZTomoData = Tomo_2QProcess('qubit1','q9','qubit2','q8',...
'process','CZ','reps',1,...
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

setQSettings('r_avg',250);
numGates = 1:1:20;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);
   
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

setQSettings('r_avg',250);
numGates = 1:1:40;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);


%%
q = 'q8';
setQSettings('r_avg',2000,q);

tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
XYGate ={'X','X/2','X/4'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
end

setQSettings('r_avg',3000,q);
ramsey('qubit',q,'mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:10e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
  
q = 'q9';
setQSettings('r_avg',2000,q);

tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
XYGate ={'X','X/2','X/4'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
end

setQSettings('r_avg',3000,q);
ramsey('qubit',q,'mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:10e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
  
%%