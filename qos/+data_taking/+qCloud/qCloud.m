function qCloud()
    cd('D:\QOSv1.1\qos');
    addpath('D:\QOSv1.1\qos\dlls');

    QS = qes.qSettings.GetInstance('D:\settings');
    QS.user = 'yulin';
    QS.CreateHw();
    
    qNames = data_taking.public.util.allQNames();
    for ii = 1:numel(qNames)
        data_taking.public.util.setZDC(qNames{ii});
    end
end