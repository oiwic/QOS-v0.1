classdef randBenchMarking4Opt < sqc.measure.randBenchMarking
    % a wrapper of randBenchMarking as a measure for gate optimization
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

    methods
        function obj = randBenchMarking4Opt(qubits,numGates,numShots)
			obj@sqc.measure.randBenchMarking(qubits,[],numGates,numShots);
            obj.numericscalardata = true;
            obj.name = 'Sequence Error';
        end
        function Run(obj)
            Run@sqc.measure.randBenchMarking(obj);
            obj.data = 1-mean(obj.data(:,1));
            obj.dataready = true;
        end
    end
end
