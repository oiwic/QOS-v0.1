%% fully auto callibration
% qubits = {'q7','q8'};
qubits = {'q8_7k','q9'};

for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    try
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    catch
    end
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2','X/4'};
    for jj = 1:numel(XYGate)
        try
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
        catch
        end
    end
end

setQSettings('r_avg',300);
numGates = 1:1:15;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8_7k',...
       'process','CZ','numGates',numGates,'numReps',100,...
       'gui',true,'save',true);
   
   
for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    for kk = 1:numel(XYGate)
        try
        tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
        catch
        end
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
        tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
        XYGate ={'X','X/2','X/4'};
        for jj = 1:numel(XYGate)
            try
            tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
            tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
            catch
            end
        end

        XYGate ={'X','X/2'};
        numGates = 1:5:150;
        [Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
               'process',XYGate{kk},'numGates',numGates,'numReps',70,...
               'gui',true,'save',true);
    end
end


for ii = 1:numel(qubits)
    q = qubits{ii};
    setQSettings('r_avg',2000,q);
    tuneup.correctf01byRamsey('qubit',q,'robust',true,'gui',true,'save',true);
    tuneup.xyGateAmpTuner('qubit',q,'gateTyp','X','AE',false,'gui',true,'save',true);
    tuneup.iq2prob_01('qubit',q,'numSamples',1e4,'gui',true,'save',true);
    XYGate ={'X','X/2','X/4'};
    for jj = 1:numel(XYGate)
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',21,'gui',true,'save',true);
        tuneup.xyGateAmpTuner('qubit',q,'gateTyp',XYGate{jj},'AE',true,'AENumPi',41,'gui',true,'save',true);
    end
end

setQSettings('r_avg',300);
numGates = 1:1:15;
[Pref,Pi] = randBenchMarking('qubit1','q9','qubit2','q8_7k',...
       'process','CZ','numGates',numGates,'numReps',100,...
       'gui',true,'save',true);

