classdef (Abstract = true) tomography < qes.measurement.measurement
    % tomography
	% data: m^n by 2^n, m, number of tomography operations, n, number of qubits
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com


% 
%             if ~isempty(scz.dynamicPhase)
%                 q1.g_XY_phaseOffset = q1.g_XY_phaseOffset + scz.dynamicPhase(1);
%                 q2.g_XY_phaseOffset = q2.g_XY_phaseOffset + scz.dynamicPhase(2);
%             end

	properties
		showProgress@logical scalar = true; % print measurement progress to command window or not
		progInfoPrefix = ''
        xyGatePhaseOffset; % introduced to shift xy gate phase in single qubit phase tomo
	end
	properties (SetAccess = private)
		qubits
    end
    properties (GetAccess = private, SetAccess = private)
		readoutGates
		process % for process tomography
        R
        numReadouts
    end
    methods
        function obj = tomography(qubits, readoutGates)
			import sqc.op.physical.gate.*
			if ~iscell(qubits)
                qubits = {qubits};
            end
            numTomoQs = numel(qubits);
            for ii = 1:numTomoQs
                if ischar(qubits{ii})
                    qubits{ii} = sqc.util.qName2Obj(qubits{ii});
				end
            end
            obj = obj@qes.measurement.measurement([]);
            obj.xyGatePhaseOffset = zeros(1,numTomoQs);
			obj.qubits = qubits;
			obj.readoutGates = cell(1,numTomoQs);
            obj.numReadouts = numel(readoutGates);
            for ii = 1:obj.numReadouts
                readoutGates{ii} = str2func(['@(q)sqc.op.physical.gate.',readoutGates{ii},'(q)']);
            end
			for ii = 1:numTomoQs
                for jj = 1:obj.numReadouts
                    % obj.readoutGates{numTomoQs-ii+1}{jj} = feval(readoutGates{jj},obj.qubits{ii});
                    obj.readoutGates{ii}{jj} = feval(readoutGates{jj},obj.qubits{ii});
                end
            end
            obj.numericscalardata = false;
            obj.R = sqc.measure.resonatorReadout(obj.qubits);
        end
        function Run(obj)
            Run@qes.measurement.measurement(obj);
			numTomoQs = numel(obj.qubits);
			lpr = qes.util.looper_(obj.readoutGates);
			data = nan*ones(obj.numReadouts^numTomoQs,2^numTomoQs);
			numShots = obj.numReadouts^numTomoQs;
			idx = 0;
			while true
				idx = idx + 1;
				if obj.showProgress
					home;
					disp(sprintf('%sSate tomography: %0.0f of %0.0f',...
						obj.progInfoPrefix, idx-1, numShots));
				end
				rGates = lpr();
				if isempty(rGates)
					break;
                end
%                 if numTomoQs == 1 &&...
%                     isa(rGates{1},'sqc.op.physical.gate.XY_base')
%                     rGates{1}.phaseOffset = obj.xyGatePhaseOffset;
%                 end
                
                
                for uu = 1:numTomoQs
                    if isa(rGates{uu},'sqc.op.physical.gate.XY_base')
                        rGates{uu}.phaseOffset = obj.xyGatePhaseOffset(uu);
                    end
                end

				P = rGates{1};
                
%                 if idx == 7
%                     kkk = 1;
%                 end
                
				for ii = 2:numTomoQs
					P = P.*rGates{ii};
				end
				if ~isempty(obj.process)
					P = obj.process*P;
                end
				obj.R.delay = P.length;
				P.Run();
				data(idx,:) = obj.R();
			end
            obj.data = data;
			obj.dataready = true;
        end
    end
	methods(Hidden = true)
		function setProcess(obj,p)
			% for process tomography
			if ~isempty(p) && ~isa(p,'sqc.op.physical.operator')
				throw(MException('QOS_stateTomography:invalidInput',...
						'the input is not a valid quantum operator.'));
            end
            % this ristriction is remved for conditions like a two qubit
            % process but read only one of the qubit
% 			if ~qes.util.identicalArray(p.qubits,obj.qubits)
% 				throw(MException('QOS_stateTomography:differentQubtSet',...
% 						'the input process acts on a different qubit set than the state tomography qubits.'));
% 			end
			obj.process = p;
		end
	end
end