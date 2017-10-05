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
qc.measure.gateOptimizer.czOptPhaseAmp({'q7','q8'},4,20,1500, 100);

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

QS = qes.qSettings.GetInstance();
QS.saveSSettings({'shared','g_cz','q7_q8','aczLn'},150);
   
qc.measure.gateOptimizer.czOptPhaseAmp({'q7','q8'},4,20,1500, 100);

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

QS = qes.qSettings.GetInstance();
QS.saveSSettings({'shared','g_cz','q7_q8','aczLn'},100);
   
qc.measure.gateOptimizer.czOptPhaseAmp({'q7','q8'},4,20,1500, 100);

setQSettings('r_avg',1500);
numGates = 1:1:30;
[Pref,Pi] = randBenchMarking('qubit1','q7','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);
   
   
   
   
   
   
   
   
   
   