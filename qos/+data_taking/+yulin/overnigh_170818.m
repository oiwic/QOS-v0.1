q = 'q8';
setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
end

spin_echo('qubit',q,'mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:29e3],'detuning',[5]*1e6,...
      'notes','','gui',true,'save',true);
  
T1_1('qubit',q,'biasAmp',[0],'biasDelay',20,'time',[0:100:29e3],...
      'gui',true,'save',true);

setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',200);
numGates = 1:2:50;
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X','numGates',numGates,'numReps',100,...
       'gui',true,'save',true);
   
setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',200);
numGates = 1:2:50;
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',100,...
       'gui',true,'save',true);

setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',200);
numGates = 1:2:50;
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','Y','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);