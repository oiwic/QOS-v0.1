setQSettings('r_avg',5000);
CZTomoData = Tomo_2QProcess('qubit1','q5','qubit2','q6',...
       'process','CZ',...
       'notes','','gui',true,'save',true);
toolbox.data_tool.showprocesstomo(CZTomoData,CZTomoData);

sqc.measure.gateOptimizer.czOptPhase({'q5','q6'},4,20,1500, 50);

setQSettings('r_avg',5000);
CZTomoData = Tomo_2QProcess('qubit1','q5','qubit2','q6',...
       'process','CZ',...
       'notes','','gui',true,'save',true);
toolbox.data_tool.showprocesstomo(CZTomoData,CZTomoData);

setQSettings('r_avg',1500);
numGates = [1:1:20];
[Pref,Pi] = randBenchMarking('qubit1','q5','qubit2','q6',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);

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

sqc.measure.gateOptimizer.czOptPhase({'q5','q6'},4,20,1500, 50);

setQSettings('r_avg',1500);
numGates = [1:1:20];
[Pref,Pi] = randBenchMarking('qubit1','q5','qubit2','q6',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);

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
numGates = [1:1:20];
[Pref,Pi] = randBenchMarking('qubit1','q5','qubit2','q6',...
       'process','CZ','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
%%
qubits = {'q5'};%'q9','q7','q8'
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
ramsey('qubit','q5','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:4e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
ramsey('qubit','q5','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:4e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
ramsey('qubit','q5','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:4e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
spin_echo('qubit','q5','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:4e3],'detuning',[5]*1e6,...
      'notes','','gui',true,'save',true);  
  

qubits = {'q6'};%'q9','q7','q8'
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
ramsey('qubit','q6','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:4e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
ramsey('qubit','q6','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:4e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
ramsey('qubit','q6','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:4e3],'detuning',[5]*1e6,...
      'dataTyp','P','phaseOffset',0,'notes','','gui',true,'save',true);
  
spin_echo('qubit','q6','mode','dp',... % available modes are: df01, dp and dz
      'time',[0:20:4e3],'detuning',[5]*1e6,...
      'notes','','gui',true,'save',true);
%%

q = 'q5';
tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);

setQSettings('r_avg',800);
freq = 4.22e9:0.4e6:4.6e9;
spectroscopy111_zpa('biasQubit','q5','biasAmp',[8000:150:1.6e4],...
       'driveQubit','q5','driveFreq',[freq],...
       'readoutQubit','q5','dataTyp','P',...
       'notes','','gui',true,'save',true);   

   