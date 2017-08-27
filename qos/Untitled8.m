q = 'q8';
setQSettings('r_avg',2000,q);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',900);
numGates = 1:5:100;
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);
   
setQSettings('r_avg',2000,q);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',900);
numGates = 1:5:100;
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);
%%   
q = 'q9';
setQSettings('r_avg',2000,q);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',900);
numGates = 1:5:100;
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);
   
setQSettings('r_avg',2000,q);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

setQSettings('r_avg',900);
numGates = 1:5:100;
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);
%%
q = 'q9';
setQSettings('r_avg',2000,q);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

ramsey('qubit',q,'mode','dp',... % available modes are: df01, dp and dz
      'time',[0:10:16e3],'detuning',[50]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','before reduce repetition time.','gui',true,'save',true);
  
T1_1('qubit',q,'biasAmp',[0],'biasDelay',20,'time',[0:100:29e3],...
      'notes','before reduce repetition time.','gui',true,'save',true);
  
q = 'q8';
setQSettings('r_avg',2000,q);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
end

ramsey('qubit',q,'mode','dp',... % available modes are: df01, dp and dz
      'time',[0:10:16e3],'detuning',[50]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','before reduce repetition time.','gui',true,'save',true); 
  
T1_1('qubit',q,'biasAmp',[0],'biasDelay',20,'time',[0:100:29e3],...
      'notes','before reduce repetition time.','gui',true,'save',true);
   
