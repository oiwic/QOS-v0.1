cd('D:\QOSv1.1\qos');
addpath('D:\QOSv1.1\qos\dlls');
QCLOUD_SETTINGS_PATH = 'D:\data\qCloud\settings\';
qcpInstatnce = qcp.qCloudPlatform.GetInstance(QCLOUD_SETTINGS_PATH);
qcpInstatnce.Start();
%%
sysConfig = qes.util.loadSettings(QCLOUD_SETTINGS_PATH,{'systemConfig'});
% overwrite default
qcpInstatnce.updateSystemConfig(sysConfig);
%%
sysStatus = qes.util.loadSettings(QCLOUD_SETTINGS_PATH,{'systemStatus'});
% overwrite default
qcpInstatnce.updateSystemStatus(sysStatus);
%%
QS = qes.qSettings.GetInstance();
oneQFidelities = QS.loadSSettings({'shared','qCloud','oneQGateFidelities'});
% overwrite default
qcpInstatnce.updateOneQGateFidelities(oneQFidelities);

%%
QS = qes.qSettings.GetInstance();
twoQFidelities = QS.loadSSettings({'shared','qCloud','twoQGateFidelities'});
% overwrite default
qcpInstatnce.updateTwoQGateFidelities(twoQFidelities);
%%
qcpInstatnce.RunTask();
