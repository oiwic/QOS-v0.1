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

setQSettings('r_avg',3000,'q8');
setQSettings('r_avg',3000,'q9');
acz_ampLength('controlQ','q9','targetQ','q8',...
       'dataTyp','P','readoutQubit','q9',...
       'czLength',[60:16:120],'czAmp',[2.755e4-7000:50:2.755e4+2000],'cState','0',...
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
   
setQSettings('r_avg',3000,'q8');
setQSettings('r_avg',3000,'q9');
acz_ampLength('controlQ','q9','targetQ','q8',...
       'dataTyp','P','readoutQubit','q9',...
       'czLength',[60:16:120],'czAmp',[2.755e4-7000:50:2.755e4+2000],'cState','1',...
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
   
setQSettings('r_avg',3000,'q8');
setQSettings('r_avg',3000,'q9');
acz_ampLength('controlQ','q9','targetQ','q8',...
       'dataTyp','P','readoutQubit','q8',...
       'czLength',[10:8:300],'czAmp',[2.755e4-7000:150:2.755e4+2000],'cState','0',...
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
   
setQSettings('r_avg',3000,'q8');
setQSettings('r_avg',3000,'q9');
acz_ampLength('controlQ','q9','targetQ','q8',...
       'dataTyp','P','readoutQubit','q8',...
       'czLength',[10:8:300],'czAmp',[2.755e4-7000:150:2.755e4+2000],'cState','1',...
       'notes','','gui',true,'save',true);