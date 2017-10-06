import sqc.op.physical.*
import sqc.measure.*
import sqc.util.qName2Obj

q1 = qName2Obj('q7');
q2 = qName2Obj('q8');

I1 = gate.I(q1);
X1 = gate.X(q1);
Y1 = gate.Y(q1);
X2p1 = gate.X2p(q1);
X2m1 = gate.X2m(q1);
Y2p1 = gate.Y2p(q1);
Y2m1 = gate.Y2m(q1);

I2 = gate.I(q2);
X2 = gate.X(q2);
Y2 = gate.Y(q2);
X2p2 = gate.X2p(q2);
X2m2 = gate.X2m(q2);
Y2p2 = gate.Y2p(q2);
Y2m2 = gate.Y2m(q2);

CZ = gate.CZ(q1,q2);

proc0 =  CZ*Y2p1;
proc =  proc0*CZ;

R = resonatorReadout({q1,q2});
R.delay = proc.length;

proc.Run();
data = R()