% tomography and randomized bnenchmarking
%%
q = 'q5';
setQSettings('r_avg',10000);
state = '|1>';
data = Tomo_1QState('qubit',q,'state',state,'gui',true,'save',true);
% rho = sqc.qfcns.stateTomoData2Rho(data);
% h = figure();bar3(real(rho));h = figure();bar3(imag(rho));
%%
q = 'q7';
setQSettings('r_avg',10000);
process = 'X';
data = Tomo_1QProcess_animation('qubit',q,'process',process,'numPts',10,'notes','','save',true);
%%
gate = 'X/2';
data = Tomo_1QProcess('qubit','q6','process',gate,'gui',true);
%%
setQSettings('r_avg',10000);
twoQStateTomoData = Tomo_2QState('qubit1','q5','qubit2','q6',...
  'state','|10>',...
 'notes','','gui',true,'save',true);
%%
qubits = {'q7','q8','q9'};
setQSettings('r_avg',50000,qubits);
twoQStateTomoData = Tomo_mQState('qubits',qubits,...
  'state','1',...
 'notes','','gui',true,'save',true);
%%
q = 'q9';
setQSettings('r_avg',1500);
numGates = int16(unique(round(logspace(1,log10(200),7))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X/2','numGates',numGates,'numReps',40,...
       'gui',true,'save',true);
%%