%%
% qubits = {'q9','q8'};
% for ii = 1:numel(qubits)
%     q = qubits{ii};
%     setQSettings('r_avg',2000,q);
%     tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
%     tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
%     tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
%     XYGate ={'X','X/2'};
%     for jj = 1:numel(XYGate)
%         tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
%     end
% end

%%
q = 'q9';
setQSettings('r_avg',500);
numGates = 1:5:100;
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);

tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);	   
sqc.qfcns.gateOptimizer.xyGateOptWithDrag(q,100,50,500,20);

setQSettings('r_avg',500);
numGates = 1:5:100;
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);
%%	   
q = 'q8';
setQSettings('r_avg',500);
numGates = 1:5:100;
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);
	   
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);	   
sqc.qfcns.gateOptimizer.xyGateOptWithDrag(q,100,50,500,20);

setQSettings('r_avg',500);
numGates = 1:5:100;
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);
	   
%%
tuneup.iq2prob_01('qubit','q8','numSamples',1e4,'gui',true,'save',true);
tuneup.iq2prob_01('qubit','q9','numSamples',1e4,'gui',true,'save',true);
sqc.qfcns.gateOptimizer.czOptPhaseAmp({'q9','q8'},3,50,500,25);

tuneup.iq2prob_01('qubit','q8','numSamples',1e4,'gui',true,'save',true);
tuneup.iq2prob_01('qubit','q9','numSamples',1e4,'gui',true,'save',true);
setQSettings('r_avg',500,'q8');
setQSettings('r_avg',500,'q9');
numGates = 1:1:20;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',50,...
       'gui',true,'save',true);

%%	   
q = 'q8';	   
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);	   
sqc.qfcns.gateOptimizer.xyGateOptWithDrag(q,100,50,500,20);
q = 'q9';	   
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);	   
sqc.qfcns.gateOptimizer.xyGateOptWithDrag(q,100,50,500,20);
tuneup.iq2prob_01('qubit','q8','numSamples',1e4,'gui',true,'save',true);
tuneup.iq2prob_01('qubit','q9','numSamples',1e4,'gui',true,'save',true);
sqc.qfcns.gateOptimizer.czOptPhaseAmp({'q9','q8'},3,70,600,25);

tuneup.iq2prob_01('qubit','q8','numSamples',1e4,'gui',true,'save',true);
tuneup.iq2prob_01('qubit','q9','numSamples',1e4,'gui',true,'save',true);
setQSettings('r_avg',600,'q8');
setQSettings('r_avg',600,'q9');
numGates = 1:1:15;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);



