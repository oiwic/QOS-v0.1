q = 'q5';
setQSettings('r_avg',1500);
tuneup.iq2prob_01('qubits',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byPhase('qubits',q,'delayTime',0.6e-6,'gui','true','save',true);
% tuneup.updatef01byPhase('qubits',q,'delayTime',0.6e-6,'gui','true','save',true);
tuneup.iq2prob_01('qubits',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X/2','AE',true,'AENumPi',31,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',true,'AENumPi',31,'gui',true,'save',true);
tuneup.iq2prob_01('qubits',q,'numSamples',1e4,'gui',true,'save',true);

%%
q = 'q3';
tuneup.iq2prob_01('qubits',q,'numSamples',1e4,'gui',true,'save',true);
%%
q = 'q6';
setQSettings('r_avg',1500);
tuneup.iq2prob_01('qubits',q,'numSamples',1e4,'gui',true,'save',true);
tuneup.correctf01byPhase('qubits',q,'delayTime',0.6e-6,'gui','true','save',true);