% setQSettings('r_avg',2000);
% qubits = {'q1','q2','q3','q4','q5','q6','q7','q8','q9','q10','q11'};
% qubits = {'q3','q4'};
% tuneup.correctf01byPhase('qubits',qubits,'delayTime',1e-6,'gui','true','save','ask');

% qubits = {'q1','q3','q5','q7','q9','q11'};
% qubits = {'q2','q4','q6','q8','q10','q12'};
% tuneup.correctf01byPhase('qubits',qubits,'delayTime',1e-6,'gui','true','save','ask');

gui = true;
save = true;
iq2ProbNumSamples = 2e4;
correctf01DelayTime = 1e-6;

qubitGroups = {{'q1','q4','q7','q10'},...
               {'q2','q5','q8','q11'},...
               {'q3','q6','q9'}};

setQSettings('r_avg',2000);
%%
for ii = 1:numel(qubitGroups)
    tuneup.iq2prob_01_parallel('qubits',qubitGroups{ii},'numSamples',iq2ProbNumSamples,'gui',gui,'save',save);
    tuneup.correctf01byPhase('qubits',qubitGroups{ii},'delayTime',correctf01DelayTime,'gui',gui,'save',save);
end

%%
tuneup.xyGateAmpTuner_parallel('qubit',q,'gateTyp','X/2','AE',true,'gui',true,'save','askMe');