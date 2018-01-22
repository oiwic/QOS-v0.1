classdef qCloudPlatform < handle
    % Quantum Computing Cloud Platform backend
    % http://quantumcomputer.ac.cn/index.html
    
% Copyright 2018 Yulin Wu, USTC
% mail4ywu@gmail.com/mail4ywu@icloud.com

    properties(SetAccess = private)
        started = false
        running = false
    end
    properties (SetAccess = private, GetAccess = private)
        qCloudSettingsPath
        connection
        logger
        
        user
        qosSettingsRoot
        dataPath
        defaultResultMsgCN
        defaultResultMsgEN
        
        runErrorCount = 0
        runtErrorTime
        
        noConcurrentCZ
    end
    methods (Access = private)
        function obj = qCloudPlatform(qCloudSettingsPath)
            obj.qCloudSettingsPath = qCloudSettingsPath;
            obj.defaultResultMsgCN = qes.util.loadSettings(qCloudSettingsPath, 'defaultResultMsgCN');
            obj.defaultResultMsgEN = qes.util.loadSettings(qCloudSettingsPath, 'defaultResultMsgEN');
            pushoverAPIKey = qes.util.loadSettings(qCloudSettingsPath, {'pushover','key'});
            pushoverReceiver = qes.util.loadSettings(qCloudSettingsPath, {'pushover','receiver'});
            obj.user = qes.util.loadSettings(qCloudSettingsPath, 'user');
            obj.qosSettingsRoot = qes.util.loadSettings(qCloudSettingsPath, 'qosSettingsRoot');
            logPath = qes.util.loadSettings(qCloudSettingsPath, 'logPath');
            logfile = fullfile(logPath, [datestr(now,'yyyy-mm-dd_HH-MM-SS'),'_qos.log']);
            logger = qes.util.log4qCloud.getLogger(logfile);
            logger.setFilename(logfile);
            logger.setCommandWindowLevel(logger.INFO);
            logger.setLogLevel(logger.INFO);  
            logger.setNotifier(pushoverAPIKey,pushoverReceiver);
            obj.logger = logger;
            dataPath = qes.util.loadSettings(qCloudSettingsPath, 'dataPath');
            if ~isdir(dataPath)
                obj.logger.error('qCloud:invalidPath',sprintf('data path %s is not a valid path.', dataPath));
                throw(MException('QOS:qCloudPlatform:invalidDataPath',sprintf('data path %s is not a valid path.', dataPath)));
            end
            obj.dataPath = dataPath;
            obj.noConcurrentCZ = qes.util.loadSettings(qCloudSettingsPath, 'noConcurrentCZ');
        end
        function calibration(obj)
            % TODO
        end
        function [result, singleShotEvents, waveformSamples, finalCircuit] =...
                runCircuit(obj,circuit,opQs,measureQs,measureType)
            import sqc.op.physical.*
            import sqc.measure.*
            import sqc.util.qName2Obj

            numOpQs = numel(opQs);
            opQubits = cell(1,numOpQs);
            for ii = 1:numOpQs
                opQubits{ii} = qName2Obj(opQs{ii});
            end
            obj.logger.info('qCloud.runCircuit','parsing circuit...');
            if obj.noConcurrentCZ
                finalCircuit = sqc.op.physical.gateParser.shiftConcurrentCZ(circuit);
            else
                finalCircuit = circuit;
            end
            process = sqc.op.physical.gateParser.parse(opQubits,circuit,obj.noConcurrentCZ);
            obj.logger.info('qCloud.runCircuit','parse circuit done.');
            obj.logger.info('qCloud.runCircuit','running circuit...');
            process.logSequenceSamples = true;
            waveformLogger = sqc.op.physical.sequenceSampleLogger.GetInstance();
            numMeasureQs = numel(measureQs);
            measureQubits = cell(1,numel(numMeasureQs));
            for ii = 1:numMeasureQs
                measureQubits{ii} = qName2Obj(measureQs{ii});
            end
            switch measureType
                case 'Mtomoj'
                    R = stateTomography(measureQubits,true);
                    R.setProcess(process);
                case 'Mtomop'
                    R = stateTomography(measureQubits,false);
                    R.setProcess(process);
                case 'Mphase'
                    R = phase(measureQubits);
                    R.setProcess;
                case 'Mzj'
                    R = resonatorReadout(measureQubits,true,false);
                    process.Run();
                case 'Mzp'
                    R = resonatorReadout(measureQubits,false,false);
                    process.Run();
                otherwise
                    obj.logger.error('qCloud:runTask:unsupportedMeasurementType',...
                        ['unsupported measurement type: ', measureType]);
                    throw(MException('QOS:qCloudPlatform:unsupportedMeasurementType',...
                        ['unsupported measurement type: ', measureType]));
            end
            result = R();
            singleShotEvents = R.extradata;
            [qubits, xySequenceSamples, zSequenceSamples] = waveformLogger.get();
            obj.logger.info('qCloud.runCircuit','run circuit done.');
            if numel(qubits) ~= numOpQs
                obj.logger.error('qCloud:runTask:waveformSampleException',...
                    'number of waveform sample qubits not equal to number of operation qubits.');
                waveformSamples = [];
                return;
            end
            sampleLength = 0;
            for ii = 1:numOpQs
                sampleLength = max([sampleLength, size(xySequenceSamples{ii},2),...
                    size(zSequenceSamples{ii},2)]);
            end
            waveformSamples = zeros(3*numOpQs,sampleLength);
            for ii = 1:numOpQs
                ind = 3*(ii-1);
                if ~isempty(xySequenceSamples{ii})
                    waveformSamples(ind+1,:) = xySequenceSamples{ii}(1,:);
                    waveformSamples(ind+2,:) = xySequenceSamples{ii}(2,:);
                end
                if ~isempty(zSequenceSamples{ii})
                    waveformSamples(ind+3,:) = zSequenceSamples{ii};
                end
            end
        end
    end
    methods (Static = true)
        function obj = GetInstance(qCloudSettingsPath)
            persistent instance;
            if isempty(instance) || ~isvalid(instance)
                if nargin < 1 || ~isdir(qCloudSettingsPath)
                    throw(MException('QOS:qCloudPlatform:notEnoughArguments',...
                        'qCloudSettingPath not given or not a valid path.'))
                else
                    instance = qcp.qCloudPlatform(qCloudSettingsPath);
                end
            end
            obj = instance;
        end
    end
    methods
        function Start(obj)
            if obj.started
                return;
            end
            obj.logger.info('qCloud.startup','initilizing QOS settings...');
            try
                QS = qes.qSettings.GetInstance(obj.qosSettingsRoot);
            catch ME
                if strcmp(ME.identifier,'QOS:qSettings:invalidRootPath')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            try
                QS.user = obj.user;
            catch ME
                if strcmp(ME.identifier,'QOS:qSettings:invalidUser')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            try
                selectedSession = qes.util.loadSettings(obj.qosSettingsRoot, {QS.user,'selected'});
            catch ME
                if strcmp(ME.identifier,'QOS:loadSettings:settingsNotFound')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            if isempty(selectedSession)
                obj.logger.fatal('qCloud.startup', sprintf('no selected session for %s in QOS settings.', QS.user));
                obj.logger.notify();
                throw(MException('QOS:qCloud:startup',sprintf('no selected session for %s in QOS settings.',QS.user)));
            end
            try
                sessionDate = datenum(selectedSession(2:end),'yymmdd');
                newSession = ['s',datestr(now,'yymmdd')];
                if sessionDate < floor(now)
                    qes.util.copySession(selectedSession,newSession);
                end
            catch ME
                if strfind(ME.identifier,'QOS:copySession:')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            try
                QS.SS(newSession);
            catch ME
                if strfind(ME.identifier,'QOS:qSettings:')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            try
                selectedHwSettings = qes.util.loadSettings(QS.root,{'hardware','selected'});
            catch ME
                if strcmp(ME.identifier,'QOS:loadSettings:settingsNotFound')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            if isempty(selectedHwSettings)
                obj.logger.fatal('qCloud.startup', 'no selected hardware settings.');
                obj.logger.notify();
                throw(MException('QOS:qCloud:startup','no selected hardware settings.'));
            end
            obj.logger.info('qCloud.startup','initilizing QOS settings done.');
        %%
            obj.logger.info('qCloud.startup','creating hardware objects...');
            try
                QS.CreateHw();
            catch ME
                if strfind(ME.identifier, 'QOS:loadSettings:')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                elseif strfind(ME.identifier, 'QOS:hwCreator:illegalHaredwareSettings')
                    obj.logger.fatal('qCloud.startup', ME.message);
                    obj.logger.notify();
                else
                    obj.logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
                    obj.logger.notify();
                end
                rethrow(ME);
            end
            obj.logger.info('qCloud.startup','creating hardware objects done.');

        %%  just in case some dc source levels has changed
            obj.logger.info('qCloud.startup','setting qubit DC bias...');
            qNames = data_taking.public.util.allQNames();
            for ii = 1:numel(qNames)
                try
                    data_taking.public.util.setZDC(qNames{ii});
                catch ME
                    obj.logger.fatal('qCloud.startup', sprintf('error in set dz bias for qubit %s: %s', qNames{ii}, ME.message));
                    obj.logger.notify();
                    rethrow(ME);
                end
            end
            obj.logger.info('qCloud.startup','setting qubit DC bias done.');
            %%

        %% 
           obj.connection = qcp.qCloudPlatformConnection.GetInstance();
           obj.started = true;
           obj.logger.info('qCloud.startup','qCloud backend started up successfully.');
           obj.logger.notify();
        end
        function Restart(obj)
            obj.started = false;
            obj.logger.info('qCloud.restart','restarting qCloud...');
            if obj.running % otherwise STANDBY
                obj.logger.info('qCloud.restart','qCloud running, stopping qCloud...');
                obj.Stop();
            end
            try
                QS = qes.qSettings.GetInstance();
                QS.delete();
            catch
            end
            obj.logger.info('qCloud.restart','deleting hardware objects...');
            hwObjs = qes.qSettings.FindByClass('qes.hwdriver.hardware');
            for ii = 1:numel(hwObjs)
                try
                    hwObjs{ii}.delete();
                catch ME
                    obj.logger.warn('qCloud.restart',['error at deleting hardware objects: ', ME.message]);
                end
            end
            obj.logger.info('qCloud.restart','hardware objects deleted.');
            try
                obj.Start();
            catch ME
                obj.logger.fatal('qCloud.restart',['restart failed due to: ', ME.message]);
            end
            obj.logger.info('qCloud.restart','qCloud restarted.');
        end
        function Run(obj)

           obj.logger.info('qCloud.run','qCloud now running...'); 
        end
        function Stop(obj)
            % TODO...
            
            obj.logger.info('qCloud.restart','qCloud stopped.');
        end
        function RunTask(obj)
            qTask = obj.connection.getTask();
            if isempty(qTask)
                return;
            end
            obj.logger.info('qCloud.runTask',['running task: ', num2str(qTask.taskId,'%0.0f')]);
            errorMsg = '';
            try
                [result, singleShotEvents, waveformSamples, finalCircuit] =...
                    obj.runCircuit(qTask.circuit,qTask.opQubits,...
                    qTask.measureQubits,qTask.measureType);
            catch ME
                errorMsg = [ME.message,char(13),char(10)];
                obj.logger.error('qCloud.runTask.runTaskException',ME.message);
                obj.logger.notify();
                obj.runErrorCount = obj.runErrorCount + 1;
                obj.runtErrorTime(end+1) = now;
                ln = numel(obj.runtErrorTime);
                if obj.runtErrorTime(end) - obj.runtErrorTime(max(1,ln-4)) > 0.00694 % 10 min
                    throw(ME);
                end
            end
            
            taskResult = struct();
            taskResult.taskId = qTask.taskId;
            taskResult.finalCircuit = finalCircuit;
            taskResult.result = result;
            taskResult.singleShotEvents = singleShotEvents;
            taskResult.waveforms = waveformSamples;
            QS = qes.qSettings.GetInstance();
            numMQs = numel(qTask.measureQubits);
            taskResult.fidelity = -ones(numMQs,2);
            for ii = 1:numMQs
                try
                    taskResult.fidelity(ii,:) = QS.loadSSettings({qTask.measureQubits{ii},'r_iq2prob_fidelity'});
                catch ME
                    msg = sprintf('load readout fidelity for %s failed due to: %s',...
                        qTask.measureQubits{ii},ME.message);
                    errorMsg = [errorMsg,msg];
                    obj.logger.error('qCloud.runTask',msg);
                end
            end
            
            taskResult.noteCN = [obj.defaultResultMsgCN, errorMsg];
            taskResult.noteEN = [obj.defaultResultMsgEN, errorMsg];
            datafile = fullfile(obj.dataPath,sprintf('task_%08.0f.mat',qTask.taskId));
            save(datafile,'qTask','taskResult','errorMsg');
            obj.connection.pushResult(taskResult);
            obj.logger.info('qCloud.runTask',sprintf('task: %0.0f done.', qTask.taskId));
        end
        function pushTask(obj,circuit,measureQs, stats,measureType)
            % for testing
            % circuit  = {'Y2p','Y2p','Y2p',  'Y2p',  'Y2p',  'Y2p',  'Y2p',  'Y2p','Y2p',  'Y2p','Y2p';
            %    'Y2m','Y2m','Y2m',  'Y2m',  'Y2m',  'Y2m',  'Y2m',  'Y2m','Y2m',  'Y2m','Y2m'};
            % measureQs = {'q1','q2','q3','q4','q5'};
            obj.connection.pushTask(obj,circuit,measureQs,stats,measureType);
        end
        function updateSystemConfig(obj,sysConfig)
            if nargin < 2
                try
                    sysConfig = qes.util.loadSettings(obj.qCloudSettingsPath, 'systemConfig');
                catch ME
                    obj.logger.error('qCloud.updateSystemConfig',sprintf('load systemConfig settings failed: %s', ME.message));
                    return;
                end
            end
            obj.connection.updateSystemConfig(sysConfig);
        end
        function updateSystemStatus(obj,sysStatus)
            if nargin < 2
                try
                    sysStatus = qes.util.loadSettings(obj.qCloudSettingsPath, 'sysStatus');
                catch ME
                    obj.logger.error('qCloud.updateSystemStatus',sprintf('load sysStatus settings failed: %s', ME.message));
                    return;
                end
            end
            obj.connection.updateSystemStatus(sysStatus);
        end
        function updateOneQGateFidelities(obj,oneQFidelities)
            if nargin < 2
                try
                    QS = qes.qSettings.getInstance();
                    oneQFidelities = QS.loadSSettings({'shared','qCloud','oneQGateFidelities'});
                catch ME
                    obj.logger.error('qCloud.updateOneQGateFidelities',...
                        sprintf('load updateOneQGateFidelities settings failed: %s', ME.message));
                    return;
                end
            end
            qNames = fieldnames(oneQFidelities);
            for ii = 1:numel(qNames)
                s = oneQFidelities.(qNames{ii});
                s.qubit = str2double(qNames{ii}(2:end));
                obj.connection.updateOneQGateFidelities(s);
            end
        end
        function updateTwoQGateFidelities(obj,twoQFidelities)
            if nargin < 2
                try
                    QS = qes.qSettings.getInstance();
                    twoQFidelities = QS.loadSSettings({'shared','qCloud','twoQFidelities'});
                catch ME
                    obj.logger.error('qCloud.updateTwoQGateFidelities',...
                        sprintf('load updateTwoQGateFidelities settings failed: %s', ME.message));
                    return;
                end
            end
            czSets = fieldnames(twoQFidelities);
            for ii = 1:numel(czSets)
                s.cz = twoQFidelities.(czSets{ii});
                [ind1, ind2] = regexp(czSets{ii},'_q\d+_');
                s.q1= str2double(czSets{ii}(ind1+2:ind2-1));
                str = czSets{ii}(ind2:end);
                [ind1, ind2] = regexp(str,'_q\d+');
                s.q2= str2double(str(ind1+2:ind2));
                obj.connection.updateTwoQGateFidelities(s);
            end
        end
        function updateQubitParemeters(obj,qubitParameters)
            if nargin < 2
                try
                    QS = qes.qSettings.getInstance();
                    qubitParameters = QS.loadSSettings({'shared','qCloud','qubitParameters'});
                catch ME
                    obj.logger.error('qCloud.updateQubitParemeters',...
                        sprintf('load updateQubitParemeters settings failed: %s', ME.message));
                    return;
                end
            end
            qNames = fieldnames(qubitParameters);
            for ii = 1:numel(qNames)
                s = qubitParameters.(qNames{ii});
                s.qubit = str2double(qNames{ii}(2:end));
                obj.connection.updateQubitParemeters(s);
            end
        end
        
    end
end