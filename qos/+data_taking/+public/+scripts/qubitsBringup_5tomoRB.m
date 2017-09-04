% tomography and randomized bnenchmarking
%%
q = 'q8';
setQSettings('r_avg',5000,q);
state = '|0>+|1>';
data = Tomo_1QState('qubit',q,'state',state,'notes','','save',true);
rho = sqc.qfcns.stateTomoData2Rho(data);
h = figure();bar3(real(rho));h = figure();bar3(imag(rho));

%%
q = 'q9';
setQSettings('r_avg',5000,q);
state = 'H';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',100,'notes','','save',true);
%%
gate = 'Z';
data = Tomo_1QProcess('qubit','q8','process',gate,'gui',true);
%% 
setQSettings('r_avg',5000,'q8');
setQSettings('r_avg',5000,'q9');
CZTomoData = Tomo_2QProcess('qubit1','q9','qubit2','q8',...
       'process','CZ',...
       'notes','','gui',true,'save',true);
%%
twoQStateTomoData = Tomo_2QState('qubit1','q7','qubit2','q8',...
  'state','|11>',...
 'notes','','gui',true,'save',true);
%%
q = 'q8';
setQSettings('r_avg',500,q);
numGates = int16(unique(round(logspace(0,log10(100),5))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
%% two qubit gate benchmarking
setQSettings('r_avg',600);
numGates = 1:1:10;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);
%%