q = 'q9';

setQSettings('r_avg',2000,q);
tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
XYGate ={'X','X/2'};
for jj = 1:numel(XYGate)
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
end



setQSettings('r_avg',3000,q);
numPts = 60;

state = '|1>x';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|1>y';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|0>+|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|0>+i|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|0>-|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|0>-i|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
setQSettings('qr_xy_dragPulse',false,q);

state = '|1>x';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|1>y';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|0>+|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|0>+i|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|0>-|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|0>-i|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
setQSettings('qr_xy_dragPulse',true,q);

    q = 'q8';
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
    end

q = 'q8';
setQSettings('r_avg',3000,q);
numPts = 60;

state = '|1>x';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|1>y';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|0>+|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|0>+i|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|0>-|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
state = '|0>-i|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','with DRAG','save',true);
close gcf
setQSettings('qr_xy_dragPulse',false,q);

state = '|1>x';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|1>y';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|0>+|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|0>+i|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|0>-|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
state = '|0>-i|1>';
data = Tomo_1QState_animation('qubit',q,'state',state,'numPts',numPts,'notes','no DRAG','save',true);
close gcf
setQSettings('qr_xy_dragPulse',true,q);
