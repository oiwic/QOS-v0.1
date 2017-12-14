%%
import sqc.op.physical.*
import sqc.measure.*
import sqc.util.qName2Obj

q1 = qName2Obj('q9');
q2 = qName2Obj('q8');

CZ = gate.CZ(q1,q2);
I = gate.I(q1);
I.ln = CZ.length;
Z = gate.Z4p(q1);
% Z = op.Z_arbPhase(q1,pi/4);
X = gate.X(q1);

% p = CZ*X*CZ*X*CZ*X*CZ*X;
p = Z*X*Z*X*Z*X*Z*X;
p.Run();

% plot the waveforms to check