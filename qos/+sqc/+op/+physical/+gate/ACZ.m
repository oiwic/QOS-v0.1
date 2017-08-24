classdef ACZ < sqc.op.physical.operator
    % adiabatic controled Z gate
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

	properties
        aczLn % length of the acz pulse, pad length and meetup longer not included
        
        amp
        thf
        thi
        lam2
        lam3
    end
    properties (SetAccess = private)
        meetUpLonger % must be private
        padLn % must be private
        meetUpDetuneFreq
        dynamicPhase
    end
    properties (SetAccess = private, GetAccess = private)
        aczQ
        meetUpQ
    end
    methods
        function obj = ACZ(q1, q2)
			if isempty(q1.aczSettings) && isempty(q1.aczSettings)
				aczSettingsKey = sprintf('%s_%s',q1.name,q2.name);
				QS = qes.qSettings.GetInstance();
				scz = QS.loadSSettings({'shared','g_cz',aczSettingsKey});
			else
				if ~isempty(q1.aczSettings)
					scz = q1.aczSettings;
				else
					scz = q1.aczSettings;
				end
			end

            obj = obj@sqc.op.physical.operator({q1, q2});
            obj.amp = scz.amp;
            obj.thf = scz.thf;
            obj.thi = scz.thi;
            obj.lam2 = scz.lam2;
            obj.lam3 = scz.lam3;
            
            
            obj.meetUpLonger = scz.meetUpLonger;
            obj.padLn = scz.padLn;
            obj.aczLn = scz.aczLn; % must be after the setting of meetUpLonger and padLn
            if scz.aczFirstQ
                obj.aczQ = 1;
                obj.meetUpQ = 2;
            else
                obj.aczQ = 2;
                obj.meetUpQ = 1;
            end
            obj.dynamicPhase = scz.dynamicPhase;
            obj.gateClass = 'CZ';
        end
        function set.aczLn(obj,val)
            obj.aczLn = val;
            obj.length = val+sum(obj.padLn)+2*obj.meetUpLonger;
        end
    end
	methods (Hidden = true)
        function GenWave(obj)
            aczWv = qes.waveform.acz(obj.aczLn, obj.amp, obj.thf, obj.thi, obj.lam2, obj.lam3);
            padWv1 = qes.waveform.spacer(obj.padLn(1)+obj.meetUpLonger);
            padWv2 = qes.waveform.spacer(obj.padLn(2)+obj.meetUpLonger);
            obj.z_wv{1} = [padWv1, aczWv, padWv2];

            acz_q = obj.qubits{obj.aczQ};
            meetUp_q = obj.qubits{obj.meetUpQ};
            persistent da1
            if isempty(da1)
                da1 = qes.qHandle.FindByClassProp('qes.hwdriver.hardware',...
                        'name',acz_q.channels.z_pulse.instru);
            end
            obj.z_daChnl{1} = da1.GetChnl(acz_q.channels.z_pulse.chnl);
			
            persistent da2
            if obj.meetUpDetuneFreq
                wvArgs = {obj.aczLn+2*obj.meetUpLonger,...
                    sqc.util.detune2zpa(meetUp_q,obj.meetUpDetuneFreq)};
                wvSettings = struct(meetUp_q.g_detune_wvSettings); % use struct() so we won't fail in case of empty
                fnames = fieldnames(wvSettings);
                for ii = 1:numel(fnames)
                    wvArgs{end+1} = wvSettings.(fnames{ii});
                end
                meetupWv = feval(['qes.waveform.',meetUp_q.g_detune_wvTyp],wvArgs{:});

                padWv3 = qes.waveform.spacer(obj.padLn(1));
                padWv4 = qes.waveform.spacer(obj.padLn(2));
                obj.z_wv{2} = [padWv3,meetupWv,padWv4];
                if isempty(da2)
                    da2 = qes.qHandle.FindByClassProp('qes.hwdriver.hardware',...
                            'name',meetUp_q.channels.z_pulse.instru);
                end
                obj.z_daChnl{2} = da2.GetChnl(meetUp_q.channels.z_pulse.chnl);
            end
        end
    end
end