% Run Quantum Process
% Yulin Wu, 2017/8/24
%%
import sqc.op.physical.*
import sqc.measure.*
import sqc.util.qName2Obj
%%
q = qName2Obj('q8');
g1 = gate.Y2m(q);
g2 = gate.I(q);
g2.ln = 500;
g3 = gate.Y2p(q);
proc = g1*g2*g3;
R = resonatorReadout(q);
R.delay = proc.length;
proc.Run();
data = R()
%% acz(CNOT) target qubit phase, control qubit: |1>
q1 = qName2Obj('q9');
q2 = qName2Obj('q8');
g1 = gate.X(q1);
g2 = gate.Y2m(q2);
g3 = gate.CZ(q1,q2);
proc = (g1.*g2)*g3;
R = phase(q2);
R.setProcess(proc);
data = R()
%% acz(CNOT) target qubit phase, control qubit: |0>
q1 = qName2Obj('q9');
q2 = qName2Obj('q8');
g2 = gate.Y2m(q2);
g3 = gate.CZ(q1,q2);
proc = g2*g3;
R = phase(q2);
R.setProcess(proc);
data = R()
%% acz qubit phase
q1 = qName2Obj('q9');
q2 = qName2Obj('q8');
g2 = gate.Y2m(q1);
g3 = gate.CZ(q1,q2);
proc = g2*g3;
R = phase(q1);
R.setProcess(proc);
data = R()
%%
q1 = qName2Obj('q9');
q2 = qName2Obj('q8');
X1 = gate.X(q1);
X2 = gate.X(q2);
ACZ = gate.CZ(q1,q2);
mR1 = gate.I(q1);
mR2 = gate.Y2m(q2);
proc = (X1.*X2)*ACZ*(mR1.*mR2);
R = resonatorReadout({q1,q2});
R.delay = proc.length;
proc.Run();
data = R()
%%
q1 = qName2Obj('q9');
q2 = qName2Obj('q8');
X1 = gate.X(q1);
X2 = gate.X(q2);
ACZ = gate.CZ(q1,q2);

ACZ_ = gate.I(q1);
ACZ_.ln = ACZ.length;

ACZ_ = ACZ;

mR1 = gate.I(q1);
mR2 = gate.Y2m(q2);
proc = (X1.*X2)*ACZ_;
R = stateTomography({q1,q2});
R.setProcess(proc);
data = R()
