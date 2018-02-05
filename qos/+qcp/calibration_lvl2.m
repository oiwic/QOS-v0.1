function calibration_lvl2(stopFlag)

import sqc.util.getQSettings
import sqc.util.setQSettings
import data_taking.public.xmon.*

gui = true;
iq2ProbNumSamples = 2e4;
correctf01DelayTime = 0.6e-6;
fineTune = false;

AENumPi = 25;
gAmpTuneRange = 0.03;

setQSettings('r_avg',2000);
logger = qes.util.log4qCloud.getLogger();

%% single qubit gates
% qubitGroups = {{'q1','q3','q5','q7','q9','q11'},...
%                {'q2','q4','q6','q8','q10'}};
qubitGroups = {{'q1','q3','q6','q10'},...
               {'q7','q11','q4'},...
               {'q5','q8'},{'q9','q2'}};
correctf01 = {[false,true,true,true],...
               [false,true,true],...
               [true,true],[false,true]};
for ii = 1:numel(qubitGroups)
    tuneup.correctf01byPhase('qubits',qubitGroups{ii},'delayTime',correctf01DelayTime,...
        'gui',gui,'save',true,'doCorrection',correctf01{ii},'logger',logger);
    tuneup.iq2prob_01('qubits',qubitGroups{ii},'numSamples',iq2ProbNumSamples,...
        'fineTune',fineTune,'gui',gui,'save',true,'logger',logger);
    if stopFlag.val
        return;
    end
    tuneup.xyGateAmpTuner_parallel('qubits',qubitGroups{ii},'gateTyp','X/2','AENumPi',AENumPi,...
        'tuneRange',gAmpTuneRange,'gui',gui,'save',true,'logger',logger);
    tuneup.iq2prob_01('qubits',qubitGroups{ii},'numSamples',iq2ProbNumSamples,...
        'fineTune',fineTune,'gui',gui,'save',true,'logger',logger);
    if stopFlag.val
        return;
    end
end


end