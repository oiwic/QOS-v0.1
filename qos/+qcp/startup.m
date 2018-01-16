% cd('D:\QOSv1.1\qos');
% addpath('D:\QOSv1.1\qos\dlls');
% QCLOUD_SETTINGS_PATH = 'D:\data\qCloud\settings\';
% qcp.startup(QCLOUD_SETTINGS_PATH);

function startup(QCLOUD_SETTINGS_PATH)
    clc;
    QCLOUD_SETTINGS_PATH = 'D:\data\qCloud\settings\';
%%
    logPath = qes.util.loadSettings(QCLOUD_SETTINGS_PATH, 'logPath');
    pushoverAPIKey = qes.util.loadSettings(QCLOUD_SETTINGS_PATH, {'pushover','key'});
    pushoverReceiver = qes.util.loadSettings(QCLOUD_SETTINGS_PATH, {'pushover','receiver'});
    USER = qes.util.loadSettings(QCLOUD_SETTINGS_PATH, 'user');
    QOS_SETTINGS_ROOT = qes.util.loadSettings(QCLOUD_SETTINGS_PATH, 'qosSettingsRoot');
%%    
    logfile = fullfile(logPath, [datestr(now,'yyyy-mm-dd_HH-MM-SS'),'_qos.log']);
    logger = qes.util.log4qCloud.getLogger(logfile);
    logger.setFilename(logfile);
    logger.setCommandWindowLevel(logger.INFO);
    logger.setLogLevel(logger.INFO);  
    logger.setNotifier(pushoverAPIKey,pushoverReceiver);
    logger.info('qCloud.startup','start');
    logger.notify();
%%    
    logger.info('qCloud.startup','initilizing QOS settings');
    try
        QS = qes.qSettings.GetInstance(QOS_SETTINGS_ROOT);
    catch ME
        if strcmp(ME.identifier,'QOS:qSettings:invalidRootPath')
        	logger.fatal('qCloud.startup', ME.message);
            logger.notify();
        else
            logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
            logger.notify();
        end
        rethrow(ME);
    end
    try
        QS.user = USER;
    catch ME
        if strcmp(ME.identifier,'QOS:qSettings:invalidUser')
        	logger.fatal('qCloud.startup', ME.message);
            logger.notify();
        else
            logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
            logger.notify();
        end
        rethrow(ME);
    end
    try
        selectedSession = qes.util.loadSettings(QOS_SETTINGS_ROOT, {QS.user,'selected'});
    catch ME
        if strcmp(ME.identifier,'QOS:loadSettings:settingsNotFound')
        	logger.fatal('qCloud.startup', ME.message);
            logger.notify();
        else
            logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
            logger.notify();
        end
        rethrow(ME);
    end
    if isempty(selectedSession)
        logger.fatal('qCloud.startup', sprintf('no selected session for %s in QOS settings.', QS.user));
        logger.notify();
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
        	logger.fatal('qCloud.startup', ME.message);
            logger.notify();
        else
            logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
            logger.notify();
        end
        rethrow(ME);
    end
    try
        QS.SS(newSession);
    catch ME
        if strfind(ME.identifier,'QOS:qSettings:')
        	logger.fatal('qCloud.startup', ME.message);
            logger.notify();
        else
            logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
            logger.notify();
        end
        rethrow(ME);
    end
    try
        selectedHwSettings = qes.util.loadSettings(QS.root,{'hardware','selected'});
    catch ME
        if strcmp(ME.identifier,'QOS:loadSettings:settingsNotFound')
        	logger.fatal('qCloud.startup', ME.message);
            logger.notify();
        else
            logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
            logger.notify();
        end
        rethrow(ME);
    end
    if isempty(selectedHwSettings)
        logger.fatal('qCloud.startup', 'no selected hardware settings.');
        logger.notify();
        throw(MException('QOS:qCloud:startup','no selected hardware settings.'));
    end
%%
    logger.info('qCloud.startup','creating hardware objects.');
    try
        QS.CreateHw();
    catch ME
        if strfind(ME.identifier, 'QOS:loadSettings:')
            logger.fatal('qCloud.startup', ME.message);
            logger.notify();
        elseif strfind(ME.identifier, 'QOS:hwCreator:illegalHaredwareSettings')
            logger.fatal('qCloud.startup', ME.message);
            logger.notify();
        else
            logger.fatal('qCloud.startup', ['unknown error: ', ME.message]);
            logger.notify();
        end
        rethrow(ME);
    end
    
%%  just in case some dc source output levels has changed
    logger.info('qCloud.startup','set qubit DC bias');
    qNames = data_taking.public.util.allQNames();
    for ii = 1:numel(qNames)
        try
            data_taking.public.util.setZDC(qNames{ii});
        catch ME
            logger.fatal('qCloud.startup', sprintf('error in set dz bias for qubit %s: %s', qNames{ii}, ME.message));
            logger.notify();
            rethrow(ME);
        end
    end
    %%
    
    
%% 
   logger.info('qCloud.startup','qCloud backend started up successfully.');
   logger.notify();
end