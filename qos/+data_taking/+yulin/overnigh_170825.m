qubits = {'q9','q8'};
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end

tuneup.iq2prob_01('qubit','q8','numSamples',1e4,'gui',true,'save',true);
tuneup.iq2prob_01('qubit','q9','numSamples',1e4,'gui',true,'save',true);

setQSettings('r_avg',200,'q8');
setQSettings('r_avg',200,'q9');

sqc.qfcns.gateOptimizer.xyGateOptWithDrag('q9',50,70,200)
sqc.qfcns.gateOptimizer.xyGateOptWithDrag('q9',100,70,200)
sqc.qfcns.gateOptimizer.xyGateOptWithDrag('q9',200,70,200)

sqc.qfcns.gateOptimizer.czOptPhaseAmp({'q9','q8'},1,70,200)
sqc.qfcns.gateOptimizer.czOptPhaseAmp({'q9','q8'},2,70,200)
sqc.qfcns.gateOptimizer.czOptPhaseAmp({'q9','q8'},3,70,200)
sqc.qfcns.gateOptimizer.czOptPhaseAmp({'q9','q8'},5,70,200)