import sqc.util.getQSettings
import sqc.util.setQSettings
import data_taking.public.xmon.*

gui = true;
iq2ProbNumSamples = 2e4;
correctf01DelayTime = 0.6e-6;
AENumPi = 25;
gAmpTuneRange = 0.03;
fineTune = false;

qubitGroups = {{'q1','q3','q5','q7','q9','q11'},...
               {'q2','q4','q6','q8','q10'}};

correctf01 = {[true,true,true,false,false,true],...
               [true,true,true,true,true]};

setQSettings('r_avg',2000);
logger = qes.util.log4qCloud.getLogger();
% %%
% for ii = 1:numel(qubitGroups)
%     tuneup.iq2prob_01('qubits',qubitGroups{ii},'numSamples',iq2ProbNumSamples,'fineTune',fineTune,'gui',gui,'save',true,'logger',logger);
%     tuneup.correctf01byPhase('qubits',qubitGroups{ii},'delayTime',correctf01DelayTime,'gui',gui,'save',true,'doCorrection',correctf01{ii},'logger',logger);
%     tuneup.iq2prob_01('qubits',qubitGroups{ii},'numSamples',iq2ProbNumSamples,'fineTune',fineTune,'gui',gui,'save',true,'logger',logger);
% end
%% single qubit gates
qubitGroups = {{'q1','q3','q6','q10'},...
               {'q7','q11','q4'},...
               {'q5','q8'},{'q9','q2'}};
correctf01 = {[true,true,true,true],...
               [false,true,true],...
               [true,true],[false,true]};
           
for ii = 1:numel(qubitGroups)
    tuneup.iq2prob_01('qubits',qubitGroups{ii},'numSamples',iq2ProbNumSamples,'fineTune',fineTune,'gui',gui,'save',true,'logger',logger);
    tuneup.correctf01byPhase('qubits',qubitGroups{ii},'delayTime',correctf01DelayTime,'gui',gui,'save',true,'doCorrection',correctf01{ii},'logger',logger);
    tuneup.xyGateAmpTuner_parallel('qubits',qubitGroups{ii},'gateTyp','X/2','AENumPi',AENumPi,'tuneRange',gAmpTuneRange,'gui',gui,'save',true,'logger',logger);
    tuneup.xyGateAmpTuner_parallel('qubits',qubitGroups{ii},'gateTyp','X','AENumPi',AENumPi,'tuneRange',gAmpTuneRange,'gui',gui,'save',true,'logger',logger);
    tuneup.iq2prob_01('qubits',qubitGroups{ii},'numSamples',iq2ProbNumSamples,'fineTune',fineTune,'gui',gui,'save',true,'logger',logger);
end

%% cz
czQSets = {{{'q1','q2'};{'q1','q3','q5','q11'};{'q2','q4','q6','q8','q10'}},...
           {{'q3','q2'};{'q1','q3','q5','q11'};{'q2','q4','q6','q8','q10'}},...
           {{'q3','q4'};{'q1','q3','q5','q11'};{'q2','q4','q6','q8','q10'}},...
           {{'q5','q4'};{'q1','q3','q5','q11'};{'q2','q4','q6','q8','q10'}},...
           {{'q5','q6'};{'q1','q3','q5','q11'};{'q2','q4','q6','q8','q10'}},...
           {{'q7','q6'};{'q1','q3','q5','q7','q11'};{'q2','q4','q6','q8','q10'}},...
           {{'q7','q8'};{'q1','q3','q5','q7','q11'};{'q2','q4','q6','q8','q10'}},...
           {{'q9','q8'};{'q1','q3','q5','q9','q11'};{'q2','q4','q6','q8','q10'}},...
           {{'q9','q10'};{'q1','q3','q5','q9','q11'};{'q2','q4','q6','q8','q10'}},...
           {{'q11','q10'};{'q1','q3','q5','q11'};{'q2','q4','q6','q8','q10'}},...
          };
numCZs = [7,7,7,7,7,7,7,7,7,7,7];
PhaseTolerance = 0.03;
     
for ii = 1:6 % numel(czQSets)
    tuneup.czAmplitude('controlQ',czQSets{ii}{1}{1},'targetQ',czQSets{ii}{1}{2},'gui',gui,'save',true,'logger',logger);
    for jj = 2:numel(czQSets{ii})
        tuneup.czDynamicPhase_parallel('controlQ',czQSets{ii}{1}{1},'targetQ',czQSets{ii}{1}{2},'dynamicPhaseQs',czQSets{ii}{jj},...
            'numCZs',numCZs(ii),'PhaseTolerance',PhaseTolerance,...
            'gui',gui,'save',true,'logger',logger);
    end
end

%%
for ii = 1:numel(qubitGroups)
    tuneup.correctf01byPhase('qubits',qubitGroups{ii},'delayTime',correctf01DelayTime,'gui',gui,'save',true,'doCorrection',correctf01{ii},'logger',logger);
    tuneup.iq2prob_01('qubits',qubitGroups{ii},'numSamples',iq2ProbNumSamples,'fineTune',fineTune,'gui',gui,'save',true,'logger',logger);
end