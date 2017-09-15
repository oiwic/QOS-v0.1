classdef randBenchMarkingFS < sqc.measure.randBenchMarking
    % randomized benchmarking, run one fixed random gate sequence
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

    properties (SetAccess = private, GetAccess = private)
        ridx
    end
    methods
        function obj = randBenchMarkingFS(qubits, numGates,ridx)
            % the lowest fidelity reference sequence for n random gate: [~,idx] = min(Pref(:,n)); Gates{n,idx,1}
            if nargin > 2
                numGates = length(ridx)-1;
            end
            obj = obj@sqc.measure.randBenchMarking(qubits, [], numGates, 1, false);
            if nargin < 3
                if numel(qubits) == 1
                    obj.ridx = randi(24,1,obj.numGates);
                elseif numel(qubits) == 2
                    obj.ridx = randi(11520,1,obj.numGates);
                else
                    error('randBenchMarking on more than 2 qubits is not implemented.');
                end
            else
                obj.ridx = ridx;
            end
            obj.numericscalardata = true;
            obj.name = 'Sequence Error';
        end
        function Run(obj)
            Run@qes.measurement.measurement(obj);
            [gs,gf_ref,gf_i,gref_idx,gint_idx] = obj.randGates(obj.ridx);
            
            PR = gs{1,1};
            for ii = 2:obj.numGates
                PR = PR*gs{1,ii};
            end
            PR = PR*gf_ref;

            obj.R.state = 1;
            obj.R.delay = PR.length;
            PR.Run();
			obj.data = 1 - obj.R();
            obj.extradata = gref_idx;
            obj.dataready = true;
        end
    end
end