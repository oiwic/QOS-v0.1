%%
qcpInstatnce = qcp.qCloudPlatform.GetInstance();
%%
qTask = qcpInstatnce.getTask()
%%
result = struct();
result.taskId = qTask.taskId;
result.finalCircuit = qTask.circuit;
nQs = numel(qTask.opQubits);
result.result = ones(1,2^nQs)/2^nQs;
result.fidelity = ones(2,nQs);
singleShotEvents = rand(nQs,qTask.stats);
singleShotEvents(singleShotEvents > 0.7) = 1;
singleShotEvents(singleShotEvents <= 0.7) = 0;
result.singleShotEvents = singleShotEvents;
result.waveforms = ones(3*nQs,5e3);
result.noteCN = '';
result.noteEN = '';
%%
qcpInstatnce.pushResult(result);
%%
