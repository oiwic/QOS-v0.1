classdef stateTomography < sqc.measure.tomography
    % state tomography
	% data: 3^n by 2^n, n, number of qubits
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

    methods
        function obj = stateTomography(qubits)
            % -X, -Y, Z
            obj = obj@sqc.measure.tomography(qubits,{'Y2m','X2p','I'}); 
        end
        function Run(obj)
            Run@sqc.measure.tomography(obj);
        end
    end
end