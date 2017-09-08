setQSettings('r_avg',5000,'q8');
setQSettings('r_avg',5000,'q9');
CZTomoData = Tomo_2QProcess('qubit1','q9','qubit2','q8',...
       'process','CZ',...
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
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    end
end

setQSettings('r_avg',5000,'q8');
setQSettings('r_avg',5000,'q9');
CZTomoData = Tomo_2QProcess('qubit1','q9','qubit2','q8',...
       'process','CZ',...
       'notes','','gui',true,'save',true);


sqc.qfcns.gateOptimizer.czOptPhaseAmp({'q9','q8'},5,80,800,35);
close gcf;
tuneup.iq2prob_01('qubit','q8','numSamples',1e4,'gui',true,'save',true);
tuneup.iq2prob_01('qubit','q9','numSamples',1e4,'gui',true,'save',true);
setQSettings('r_avg',800,'q8');
setQSettings('r_avg',800,'q9');
numGates = 1:1:20;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8',...
'process','CZ','numGates',numGates,'numReps',80,...
'gui',true,'save',true);
close gcf;

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

setQSettings('r_avg',5000,'q8');
setQSettings('r_avg',5000,'q9');
CZTomoData = Tomo_2QProcess('qubit1','q9','qubit2','q8',...
       'process','CZ',...
       'notes','','gui',true,'save',true);