classdef phaseTomography < sqc.measure.tomography
    % phase tomography
	% data: 2 by 2
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

    methods
        function obj = phaseTomography(qubit)
            if numel(qubit) > 1
                error('phaseTomography is single qubit measurement, more than one qubit given.');
            end
            % obj = obj@sqc.measure.tomography(qubits,{'X2p','X2m','Y2p','Y2m'});
            obj = obj@sqc.measure.tomography(qubit,{'Y2p','X2m'});
        end
    end
end