setQSettings('r_avg',1500);
numGates = 1:2:30;
[Pref,Pi] = randBenchMarking('qubit1','q5','qubit2','q6',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);

qubits = {'q5','q6'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000); 
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
    XYGate ={'X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
end

sqc.measure.gateOptimizer.czOptPhase({'q5','q6'},4,20,1500, 50);

setQSettings('r_avg',1500);
numGates = 1:2:30;
[Pref,Pi] = randBenchMarking('qubit1','q5','qubit2','q6',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
   
%%

q = 'q6';
    setQSettings('r_avg',2000); 
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
    XYGate ={'X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);


setQSettings('r_avg',2000,q);
numGates = int16(unique(round(logspace(1,log10(300),25))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
   
q = 'q5';
    setQSettings('r_avg',2000); 
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
    XYGate ={'X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
    
setQSettings('r_avg',2000);
numGates = int16(unique(round(logspace(1,log10(300),25))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
   

