import data_taking.public.xmon.*
allQs = {'q9','q7','q8','q6','q5'};
% czQSet: {'aczQ','otherQ','dynamicPhaseQ1','dynamicPhaseQ2',...} % 'aczQ'
% and 'otherQ' dynamic phases are corrected by default, no need to add
% them as dynamicPaseQs
czQSets = {{'q9','q8','q5','q6','q7'},... 
           {'q7','q8','q5','q6','q9'},...
           {'q7','q6','q5','q8','q9'},...
           {'q5','q6','q7','q8','q9'},...
          };
numCZs = struct();
numCZs.q5 = 7;
numCZs.q6 = 7;
numCZs.q7 = 15;
numCZs.q8 = 15;
numCZs.q9 = 15;

tStart = now;
for ii = 1:numel(allQs)
    q = allQs{ii};
    setQSettings('r_avg',2000); 
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    % tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    setQSettings('r_avg',5000); 
    tuneup.correctf01byPhase('qubit',q,'delayTime',1e-6,'gui',true,'save',true);
    setQSettings('r_avg',2000); 
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X/2'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
    tuneup.iq2prob_01('qubit',q,'numSamples',5e4,'gui',true,'save',true);
end

setQSettings('r_avg',5000);
for ii = 1:numel(czQSets)
    czQSet = czQSets{ii};
    tuneup.czAmplitude('controlQ',czQSet{1},'targetQ',czQSet{2},'gui',true);
    for jj = 1:numel(czQSet)
        tuneup.czDynamicPhase('controlQ',czQSet{1},'targetQ',czQSet{2},'dynamicPhaseQ',czQSet{jj},...
              'numCZs',numCZs.(czQSet{jj}),'PhaseTolerance',0.03,...
              'gui','true','save',true);
    end
end
timeTaken = (now - tStart)*24

% data_taking.public.scripts.temp.GHZ_Opt_5q_NoEcho()

data_taking.public.scripts.temp.GHZ_Opt_5q_withEcho()