
%%
cd('D:\QOSv1.1\qos');
addpath('D:\QOSv1.1\qos\dlls');
QCLOUD_SETTINGS_PATH = 'D:\data\qCloud\settings\';
%%
qcpInstatnce = qcp.qCloudPlatform.GetInstance(QCLOUD_SETTINGS_PATH);
%%
qcpInstatnce.Start();
%%
QS = qes.qSettings.GetInstance();
%%
%%
qTask = qcpInstatnce.getTask()
%%
result = struct();
result.taskId = 1;
result.finalCircuit = {'X'};
nQs = 1;
% result.taskId = qTask.taskId;
% result.finalCircuit = qTask.circuit;
% nQs = numel(qTask.opQubits);
result.result = ones(1,2^nQs)/2^nQs;
result.fidelity = ones(2,nQs);
singleShotEvents = rand(nQs,1000);
% singleShotEvents = rand(nQs,qTask.stats);
singleShotEvents(singleShotEvents > 0.7) = 1;
singleShotEvents(singleShotEvents <= 0.7) = 0;
result.singleShotEvents = singleShotEvents;
result.waveforms = ones(3*nQs,5e3);
result.noteCN = '';
result.noteEN = '';
%%
qcpInstatnce.pushResult(result);
%%
numTasks = qcpInstatnce.getNumQueuingTasks()
%%
sysConfig = QS.loadSSettings({'shared','qCloud','systemConfig'});
qcpInstatnce.updateSystemConfig(sysConfig);
%%
systemStatus = QS.loadSSettings({'shared','qCloud','systemStatus'});
qcpInstatnce.updateSystemStatus(systemStatus);
%%
oneQFidelities = QS.loadSSettings({'shared','qCloud','oneQGateFidelities'});
qNames = fieldnames(oneQFidelities);
for ii = 1:numel(qNames)
    s = oneQFidelities.(qNames{ii});
    s.qubit = str2double(qNames{ii}(2:end));
    qcpInstatnce.updateOneQGateFidelities(s);
end
%%
twoQFidelities = QS.loadSSettings({'shared','qCloud','twoQGateFidelities'});
czSets = fieldnames(twoQFidelities);
for ii = 1:numel(czSets)
    s.cz = twoQFidelities.(czSets{ii});
    [ind1, ind2] = regexp(czSets{ii},'_q\d+_');
    s.q1= str2double(czSets{ii}(ind1+2:ind2-1));
    str = czSets{ii}(ind2:end);
    [ind1, ind2] = regexp(str,'_q\d+');
    s.q2= str2double(str(ind1+2:ind2));
    qcpInstatnce.updateTwoQGateFidelities(s);
end
%%
qubitParameters = QS.loadSSettings({'shared','qCloud','qubitParameters'});
qNames = fieldnames(qubitParameters);
for ii = 1:numel(qNames)
    s = qubitParameters.(qNames{ii});
    s.qubit = str2double(qNames{ii}(2:end));
    qcpInstatnce.updateQubitParemeters(s);
end