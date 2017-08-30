q = 'q8';
setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',500,q);
numGates = int16(unique(round(logspace(0,log10(200),30))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
   
setQSettings('r_avg',500,q);
numGates = int16(unique(round(logspace(0,log10(200),30))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);

%%
q = 'q9';
setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',500,q);
numGates = int16(unique(round(logspace(0,log10(200),30))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
   
setQSettings('r_avg',500,q);
numGates = int16(unique(round(logspace(0,log10(200),30))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
   
%%
q = 'q8';
setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',500,q);
numGates = int16(unique(round(logspace(0,log10(50),20))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','Z','numGates',numGates,'numReps',60,...
       'gui',true,'save',true,'note','before pulse callibration');

sqc.qfcns.gateOptimizer.zGateOpt(q,30,50,500,25);

setQSettings('r_avg',500,q);
numGates = int16(unique(round(logspace(0,log10(50),20))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','Z','numGates',numGates,'numReps',60,...
       'gui',true,'save',true,'note','after pulse callibration');

