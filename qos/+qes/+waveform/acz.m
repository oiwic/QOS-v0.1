classdef (Sealed = true) acz < qes.waveform.waveform
    % adiabatic cz gate waveform
	% reference: J. M. Martinis and M. R. Geller, Phys. Rev. A 90, 022307(2014)

% Copyright 2017 Yulin Wu, USTC
% mail4ywu@gmail.com/mail4ywu@icloud.com

    methods
        function obj = acz(length, amplitude, thf, thi, lam2, lam3)
			obj.jWaveform = com.qos.waveform.ACZ(length, amplitude, thf, thi, lam2, lam3);
        end
    end
end