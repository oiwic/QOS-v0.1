classdef phase < sqc.measure.phaseTomography
    % measure single qubit state phase
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

    methods
        function obj = phase(qubit)
            obj = obj@sqc.measure.phaseTomography(qubit);
            obj.numericscalardata = true;
            obj.name = [qubit.name,' phase(rad)'];
        end
        function Run(obj)
            Run@sqc.measure.phaseTomography(obj);
            obj.data = 1 - 2*obj.data;
            obj.data  = angle(obj.data(1,2)+1j*obj.data(2,2));
        end
    end
end