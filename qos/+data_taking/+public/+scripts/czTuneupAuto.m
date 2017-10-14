controlQ = 'q9';
targetq = 'q8';

qubits = {controlQ,targetq};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000); 
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    XYGate ={'X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
end

setQSettings('r_avg',5000);
tuneup.czAmplitude('controlQ',controlQ,'targetQ',targetq,...
    'notes','','gui',true,'save',true);

CZTomoData = Tomo_2QProcess('qubit1','q7','qubit2','q6',...
       'process','CZ',...
       'notes','','gui',true,'save',true);
toolbox.data_tool.showprocesstomo(CZTomoData,CZTomoData);

%%
sqc.measure.gateOptimizer.czOptPhase({controlQ,targetq},4,20,1500, 50);
%%
qubits = {controlQ,targetq};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000); 
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    XYGate ={'X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
end

setQSettings('r_avg',1000);
numGates = [1:2:30];
[Pref,Pi] = randBenchMarking('qubit1',controlQ,'qubit2',targetq,...
       'process','CZ','numGates',numGates,'numReps',40,...
       'gui',true,'save',true);


