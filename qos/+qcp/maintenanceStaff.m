%% maintenance staff
import qes.util.showQubitPropRecords
import qes.util.plotSettingsHis

timeRange = [now-3.5, now];

showQubitPropRecords('f01',timeRange,true);
showQubitPropRecords('zdc_amp',timeRange,true);
showQubitPropRecords('g_XY2_amp',timeRange,true);
showQubitPropRecords('r_iq2prob_center0',timeRange,true);
showQubitPropRecords('r_iq2prob_center1',timeRange,true);
qes.util.plotSettingsHis(fullfile(QS.root,QS.user,QS.session),settings,timeBounds,[],plotChange);