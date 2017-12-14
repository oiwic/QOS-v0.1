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
            % by define |0>-|1>, |0>-1j|1> and |0>, as x, y and z zero
            % phase point
            obj.data = 1 - 2*obj.data(:,2);  % 1-2*P|1> or 2*P|0> - 1
            obj.data  = angle(obj.data(1)+1j*obj.data(2));
        end
    end
end