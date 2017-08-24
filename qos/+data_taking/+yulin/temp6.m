delayTime = [-500:5:2e3];
zPulseRipple('qubit','q9_1k',...
        'delayTime',delayTime,...
       'zAmp',4e3,'gui',true,'save',true);

delayTime = [-500:5:2e3];
zPulseRipple('qubit','q9_1k',...
        'delayTime',delayTime,...
       'zAmp',0e3,'gui',true,'save',true);


for uu = 1:4

qubits = {'q9_1k'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    end
end

delayTime = [-300:5:2e3];
zPulseRipple('qubit','q9_1k',...
        'delayTime',delayTime,...
       'zAmp',4e3,'gui',true,'save',true);

delayTime = [-300:5:2e3];
zPulseRipple('qubit','q9_1k',...
        'delayTime',delayTime,...
       'zAmp',0e3,'gui',true,'save',true);

end

for uu = 1:3
qubits = {'q9_1k'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    end
end

ramsey('qubit','q9_1k','mode','dp',... 
      'time',[0:50:30e3],'detuning',[2]*1e6,...
      'dataTyp','P','phaseOffset',pi/2,'notes','','gui',true,'save',true);
  
spin_echo('qubit','q9_1k','mode','dp',... 
      'time',[0:50:30e3],'detuning',[2]*1e6,...
      'notes','','gui',true,'save',true);
end