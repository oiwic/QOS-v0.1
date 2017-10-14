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
        % detuneQubits
        detuneFreq
        detuneLonger
    end
    properties (SetAccess = private, GetAccess = private)
        aczQ
        meetUpQ
    end
    methods
        function obj = ACZ(q1, q2)
            if q1 == q2
                error('perform two qubit gate ACZ on the same qubit is not possible.');
            end
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
            
            detuneQubits = cell(1,numel(scz.detuneQubits));
            for ii = 1:numel(scz.detuneQubits)
                detuneQubits{ii} = sqc.util.qName2Obj(scz.detuneQubits{ii});
            end

            obj = obj@sqc.op.physical.operator([{q1, q2},detuneQubits]);
            obj.amp = scz.amp;
            obj.thf = scz.thf;
            obj.thi = scz.thi;
            obj.lam2 = scz.lam2;
            obj.lam3 = scz.lam3;

            obj.meetUpLonger = scz.meetUpLonger;
            obj.padLn = scz.padLn;
            
            if scz.aczFirstQ
                obj.aczQ = 1;
                obj.meetUpQ = 2;
            else
                obj.aczQ = 2;
                obj.meetUpQ = 1;
            end
            obj.dynamicPhase = scz.dynamicPhase;
%             if ~isempty(scz.dynamicPhase)
%                 q1.g_XY_phaseOffset = q1.g_XY_phaseOffset + scz.dynamicPhase(1);
%                 q2.g_XY_phaseOffset = q2.g_XY_phaseOffset + scz.dynamicPhase(2);
%             end
            obj.meetUpDetuneFreq = scz.meetUpDetuneFreq;
%             obj.detuneQubits = cell(1,scz.detuneQubits);
%             for ii = 1:numel(scz.detuneQubits)
%                 obj.detuneQubits{ii} = sqc.util.qName2Obj(scz.detuneQubits{ii});
%             end
            obj.detuneFreq = scz.detuneFreq;
            if isempty(scz.detuneLonger)
                scz.detuneLonger = 0;
            end
            obj.detuneLonger = scz.detuneLonger;
            
            obj.aczLn = scz.aczLn; % must be after the setting of meetUpLonger, padLn and detuneLonger
            %obj.length = val+sum(obj.padLn)+2*obj.meetUpLonger + 2*obj.detuneLonger;
            obj.gateClass = 'CZ';
        end
        function set.aczLn(obj,val)
            obj.aczLn = val;
            obj.length = val+sum(obj.padLn)+2*obj.meetUpLonger + 2*obj.detuneLonger;
        end
    end
	methods (Hidden = true)
        function GenWave(obj)
            aczWv = qes.waveform.acz(obj.aczLn, obj.amp, obj.thf, obj.thi, obj.lam2, obj.lam3);
            padWv1 = qes.waveform.spacer(obj.padLn(1)+obj.meetUpLonger+obj.detuneLonger);
            padWv2 = qes.waveform.spacer(obj.padLn(2)+obj.meetUpLonger+obj.detuneLonger);
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
            if obj.meetUpDetuneFreq ~= 0
                wvArgs = {obj.aczLn+2*obj.meetUpLonger,...
                    sqc.util.detune2zpa(meetUp_q,obj.meetUpDetuneFreq)};
                wvSettings = struct(meetUp_q.g_detune_wvSettings); % use struct() so we won't fail in case of empty
                fnames = fieldnames(wvSettings);
                for ii = 1:numel(fnames)
                    wvArgs{end+1} = wvSettings.(fnames{ii});
                end
                meetupWv = feval(['qes.waveform.',meetUp_q.g_detune_wvTyp],wvArgs{:});
                
%                 meetupWv = qes.waveform.rect(obj.aczLn+2*obj.meetUpLonger,...
%                     sqc.util.detune2zpa(meetUp_q,obj.meetUpDetuneFreq));

                padWv3 = qes.waveform.spacer(obj.padLn(1)+obj.detuneLonger);
                padWv4 = qes.waveform.spacer(obj.padLn(2)+obj.detuneLonger);
                
                obj.z_wv{2} = [padWv3,meetupWv,padWv4];
                if isempty(da2)
                    da2 = qes.qHandle.FindByClassProp('qes.hwdriver.hardware',...
                            'name',meetUp_q.channels.z_pulse.instru);
                end
                obj.z_daChnl{2} = da2.GetChnl(meetUp_q.channels.z_pulse.chnl);
            end
            for ii = 3:numel(obj.qubits)
                if obj.detuneFreq(ii-2) ~= 0
                    wvArgs = {obj.aczLn+2*obj.meetUpLonger+2*obj.detuneLonger,...
                        sqc.util.detune2zpa(obj.qubits{ii},obj.detuneFreq(ii-2))};
                    wvSettings = struct(obj.qubits{ii}.g_detune_wvSettings); % use struct() so we won't fail in case of empty
                    fnames = fieldnames(wvSettings);
                    for jj = 1:numel(fnames)
                        wvArgs{end+1} = wvSettings.(fnames{jj});
                    end
                    meetupWv = feval(['qes.waveform.',obj.qubits{ii}.g_detune_wvTyp],wvArgs{:});
                    
%                     meetupWv = qes.waveform.rect(obj.aczLn+2*obj.meetUpLonger+2*obj.detuneLonger,...
%                         sqc.util.detune2zpa(obj.qubits{ii},obj.detuneFreq(ii-2)));

                    padWv3 = qes.waveform.spacer(obj.padLn(1));
                    padWv4 = qes.waveform.spacer(obj.padLn(2));
                    obj.z_wv{ii} = [padWv3,meetupWv,padWv4];
                    % obj.z_wv{ii} = meetupWv ;
                    if isempty(da2)
                        da2 = qes.qHandle.FindByClassProp('qes.hwdriver.hardware',...
                                'name',obj.qubits{ii}.channels.z_pulse.instru);
                    end
                    obj.z_daChnl{ii} = da2.GetChnl(obj.qubits{ii}.channels.z_pulse.chnl);
                end
            end
        end
    end
end