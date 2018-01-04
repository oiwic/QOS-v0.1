% data_taking.public.scripts.temp.GHZ_5Q()
function GHZ_8Q()
    import sqc.measure.*
    import sqc.util.qName2Obj
    
    import sqc.op.physical.*
    import sqc.measure.*
    import sqc.util.qName2Obj
    
    rAvg = 40000;
    setQSettings('r_avg',rAvg);
    qNames = {'q1','q2','q3','q4','q5','q6','q7','q8'};          
    gateMat = {'Y2p','Y2m','I',  'I',  'I',  'I',  'I',  'I';
               'CZ','CZ',  'I',  'I',  'I',  'I',  'I',  'I';
               'I','Y2p','Y2m',  'I',  'I',  'I',  'I',  'I';
               'I','CZ',  'CZ',  'I', 'I',  'I',  'I',  'I';
               'I','I',  'Y2p','Y2m', 'I',  'I',  'I',  'I';
               'I','I',  'CZ',  'CZ', 'I',  'I',  'I',  'I';
               'I','I',  'I',  'Y2p','Y2m',  'I',  'I',  'I';
               'I','I',  'I',   'CZ','CZ',  'I',  'I',  'I';
               'I','I',  'I',    'I','Y2p',  'Y2m',  'I',  'I';
               'I','I',  'I',   'I', 'CZ',  'CZ',  'I',  'I';
               'I','I',  'I',    'I','I',  'Y2p',  'Y2m',  'I';
               'I','I',  'I',   'I', 'I',  'CZ',  'CZ',  'I';
               'I','I',  'I',    'I','I',  'I',  'Y2p',  'Y2m';
               'I','I',  'I',   'I', 'I',  'I',  'CZ',  'CZ';
               'I','I',  'I',    'I','I',  'I',  'I',  'Y2p';
               };

   qubits = cell(1,numel(qNames));
   for ii = 1:numel(qNames)
        qubits{ii} = qName2Obj(qNames{ii});
   end

   Rtomo = stateTomography(qubits);
   Rtomo.setProcess(sqc.op.physical.gateParser.parse(qubits,gateMat));
   tomoData = Rtomo();
   
   rhoIdeal = zeros(32,32);
   rhoIdeal(1,1) = 0.5;
   rhoIdeal(32,1) = 0.5;
   rhoIdeal(32,32) = 0.5;
   rhoIdeal(1,32) = 0.5;
   
   ax = qes.util.plotfcn.Rho(tomoData,[],1,true);
   qes.util.plotfcn.Rho(rhoIdeal,ax,0,false);
   
   rho = sqc.qfcns.stateTomoData2Rho(tomoData);
   fidelity = sqc.qfcns.fidelity(rho, rhoIdeal);
   title(ax(1),['fidelity: ', num2str(real(fidelity),'%0.3f')]);

   QS = qes.qSettings.GetInstance();
   timeStamp = datestr(now,'_yymmddTHHMMSS_');
   rndNum = num2str(ceil(99*rand(1,1)),'%0.0f');
   datafile = fullfile(QS.loadSSettings('data_path'),...
            ['8QGHZ',timeStamp,rndNum,'_.mat']);
   figfile = fullfile(QS.loadSSettings('data_path'),...
            ['8QGHZ',timeStamp,rndNum,'_.fig']);
        
   save(datafile,'tomoData','qubits','gateMat');
   if ishghandle(ax(1))
       saveas(get(ax(1),'Parent'),figfile);
   end

end
