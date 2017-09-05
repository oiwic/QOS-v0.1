classdef stateMod < sqc.measure.stateTomography
    % measure single qubit state phase
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

    methods
        function obj = stateMod(qubit)
            obj = obj@sqc.measure.stateTomography(qubit);
            obj.numericscalardata = true;
            obj.name = [qubit.name,' state modulu'];
        end
        function Run(obj)
            Run@sqc.measure.stateTomography(obj);
            obj.data = 1 - 2*obj.data;
            obj.data  = angle(obj.data(1,2)+1j*obj.data(2,2));
            obj.extradata = obj.data(1,2)+1j*obj.data(2,2);
        end
    end
end