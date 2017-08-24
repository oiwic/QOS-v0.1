classdef randBenchMarking4Opt < sqc.measurement.randBenchMarking
    % a wrapper of randBenchMarking as a measure for gate optimization
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

    methods
        function obj = randBenchMarkingOpt(qubits,numGates,numShots)
			obj@sqc.measurement.randBenchMarking(qubits,[],numGates,numShots);
        end
        function Run(obj)
            Run@sqc.measurement.randBenchMarking(obj);
            obj.data = 1-mean(obj.data(:,1));
        end
    end
end
