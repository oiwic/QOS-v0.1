sqc.measure.gateOptimizer.czOptPhase({'q5','q6'},4,20,1500, 50);

qubits = {'q5','q6'};%'q9','q7','q8'
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000); 
    tuneup.iq2prob_01('qubit',q,'numSamples',2e4,'gui',true,'save',true);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    XYGate ={'X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
end

setQSettings('r_avg',5000);
CZTomoData = Tomo_2QProcess('qubit1','q5','qubit2','q6',...
       'process','CZ',...
       'notes','','gui',true,'save',true);
toolbox.data_tool.showprocesstomo(CZTomoData,CZTomoData);

setQSettings('r_avg',1500);
numGates = [1:2:30];
[Pref,Pi] = randBenchMarking('qubit1','q5','qubit2','q6',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
%%

q = 'q5';
tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
sqc.measure.gateOptimizer.xyGateOptWithDrag(q,100,10,1500,35);

setQSettings('r_avg',1500,q);
numGates = int16(unique(round(logspace(log10(10),log10(150),25))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);
   
q = 'q6';
tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
sqc.measure.gateOptimizer.xyGateOptWithDrag(q,100,10,1500,35);

setQSettings('r_avg',1500,q);
numGates = int16(unique(round(logspace(log10(10),log10(150),25))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);
   
%%
sqc.measure.gateOptimizer.czOptPhase({'q5','q6'},4,20,1500, 50);

qubits = {'q5','q6'};%'q9','q7','q8'
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000); 
    tuneup.iq2prob_01('qubit',q,'numSamples',2e4,'gui',true,'save',true);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    XYGate ={'X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
end

setQSettings('r_avg',5000);
CZTomoData = Tomo_2QProcess('qubit1','q5','qubit2','q6',...
       'process','CZ',...
       'notes','','gui',true,'save',true);
toolbox.data_tool.showprocesstomo(CZTomoData,CZTomoData);

setQSettings('r_avg',1500);
numGates = [1:2:30];
[Pref,Pi] = randBenchMarking('qubit1','q5','qubit2','q6',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);