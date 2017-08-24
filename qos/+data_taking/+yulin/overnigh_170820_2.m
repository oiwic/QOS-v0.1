q = 'q5';
setQSettings('r_avg',300,q);
setQSettings('spc_driveAmp',3e3,q);
setQSettings('spc_driveLn',8e3,q);
setQSettings('spc_sbFreq',2e8,q);
f01 = getQSettings('f01',q);
freq = f01-200e6:0.3e6:f01+20e6;
spectroscopy1_zdc('qubit',q,'biasAmp',[-1.5e4:2000:1.5e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);
   
q = 'q4';
setQSettings('r_avg',300,q);
setQSettings('spc_driveAmp',3e3,q);
setQSettings('spc_driveLn',8e3,q);
setQSettings('spc_sbFreq',2e8,q);
f01 = getQSettings('f01',q);
freq = f01-200e6:0.3e6:f01+20e6;
spectroscopy1_zdc('qubit',q,'biasAmp',[-1.5e4:2000:1.5e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);
   
q = 'q3';
setQSettings('r_avg',300,q);
setQSettings('spc_driveAmp',3e3,q);
setQSettings('spc_driveLn',8e3,q);
setQSettings('spc_sbFreq',2e8,q);
f01 = getQSettings('f01',q);
freq = f01-200e6:0.3e6:f01+20e6;
spectroscopy1_zdc('qubit',q,'biasAmp',[-1.5e4:2000:1.5e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);
   
   
q = 'q2';
setQSettings('r_avg',300,q);
setQSettings('spc_driveAmp',3e3,q);
setQSettings('spc_driveLn',8e3,q);
setQSettings('spc_sbFreq',2e8,q);
f01 = getQSettings('f01',q);
freq = f01-200e6:0.3e6:f01+20e6;
spectroscopy1_zdc('qubit',q,'biasAmp',[-1.5e4:2000:1.5e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);
   
   
   
%%
q = 'q5';
setQSettings('r_avg',300,q);
setQSettings('spc_driveAmp',3e3,q);
setQSettings('spc_driveLn',8e3,q);
setQSettings('spc_sbFreq',2e8,q);
f01 = getQSettings('f01',q);
freq = f01-150e6:0.3e6:f01+20e6;
spectroscopy1_zpa('qubit',q,'biasAmp',[-0.5e4:2000:2e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);
   
q = 'q4';
setQSettings('r_avg',300,q);
setQSettings('spc_driveAmp',3e3,q);
setQSettings('spc_driveLn',8e3,q);
setQSettings('spc_sbFreq',2e8,q);
f01 = getQSettings('f01',q);
freq = f01-150e6:0.3e6:f01+20e6;
spectroscopy1_zpa('qubit',q,'biasAmp',[-0.5e4:2000:2e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);
   
q = 'q3';
setQSettings('r_avg',300,q);
setQSettings('spc_driveAmp',3e3,q);
setQSettings('spc_driveLn',8e3,q);
setQSettings('spc_sbFreq',2e8,q);
f01 = getQSettings('f01',q);
freq = f01-150e6:0.3e6:f01+20e6;
spectroscopy1_zpa('qubit',q,'biasAmp',[-0.5e4:2000:2e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);
   
   
q = 'q2';
setQSettings('r_avg',300,q);
setQSettings('spc_driveAmp',3e3,q);
setQSettings('spc_driveLn',8e3,q);
setQSettings('spc_sbFreq',2e8,q);
f01 = getQSettings('f01',q);
freq = f01-150e6:0.3e6:f01+20e6;
spectroscopy1_zpa('qubit',q,'biasAmp',[-0.5e4:2000:2e4],'driveFreq',[freq],...
       'dataTyp','S21','gui',true,'save',true);