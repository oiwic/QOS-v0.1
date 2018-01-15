classdef qCloudPlatform < handle
    % connects to Quantum Computing Cloud frontend:
    % http://quantumcomputer.ac.cn/index.html
    
% Copyright 2018 Yulin Wu, USTC
% mail4ywu@gmail.com/mail4ywu@icloud.com

    properties (SetAccess = private, GetAccess = private)
        backend
    end
    methods (Access = private)
        function obj = qCloudPlatform()
%             obj.backend = com.alibaba.quantum.impl.QuantumComputerPlatformHttpClientImplV2();
            obj.backend = com.alibaba.quantum.impl.QuantumComputerPlatformServiceV2MockImpl();
        end
    end
    methods (Static = true)
        function obj = GetInstance()
            persistent instance;
            if isempty(instance) || ~isvalid(instance)
                instance = qcp.qCloudPlatform();
            end
            obj = instance;
        end
    end
    methods
        function task = getTask(obj)
            resp = obj.backend.getTask();
            if ~resp.isSuccess()
                throw(MException('QOS:qcp:getTaskException',resp.getMessage));
            end
            jTask = resp.getData();
            task = struct();
            task.taskId = jTask.getTaskId();
            task.userId = jTask.getUserId();
            task.stats = jTask.getStats();
            circuit = cell(jTask.getCircuit());
            nc = size(circuit,2);
            idleQInd = [];
            opQubits = {};
            for ii = 1:nc
                if all(strcmp(circuit(:,ii),'I') | strcmp(circuit(:,ii),''))
                    idleQInd = [idleQInd, ii];
                end
                opQubits{end+1} = ['q',num2str(ii,'%0.0f')];
            end
            circuit(:,idleQInd) = [];
            task.circuit = circuit;
            task.opQubits = opQubits;
            task.measureQubits = cell(jTask.getMeasureQubits()).';
            submissionTime = cell(jTask.getSubmissionTime());
            task.submissionTime = submissionTime{1};
            task.useCache = jTask.isUseCache();
        end
        function pushResult(obj,result)
            jResult = com.alibaba.quantum.domain.v2.QuantumResult();
            jResult.setTaskId(result.taskId);
            jResult.setFinalCircuit(result.finalCircuit);
            jResult.setResult(result.result);
            jResult.setFidelity(result.fidelity);
            jResult.setSingleShotEvents(result.singleShotEvents);
            jResult.setWaveforms(result.waveforms);
            jResult.setNoteCN(result.noteCN);
            jResult.setNoteEN(result.noteEN);
            resp = obj.backend.pushResult(jResult);
            if ~resp.isSuccess()
                throw(MException('QOS:qcp:pushResultException',resp.getMessage));
            end
        end
    end
end