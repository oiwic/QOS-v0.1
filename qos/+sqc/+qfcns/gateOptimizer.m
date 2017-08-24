classdef gateOptimizer < qes.measurement.measurement
	% do IQ Mixer calibration
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

    properties
		maxIterNum = 20;
    end
	methods(Static = true)
		function xyGateOptWithDrag(qubit,numGates,numReps,rAvg)
            MAX_ITER = 20;
            
            
			import sqc.op.physical.*
			if ischar(qubit)
				qs = sqc.util.loadQubits();
				qubit = qs{qes.util.find(qubit,qs)};
			end
			if ~qubit.qr_xy_dragPulse
				error('DRAG disabled, can not do DRAG optimization, checking qubit settings.');
            end
			qubit.r_avg = rAvg;
            
			R = sqc.measure.randBenchMarking4Opt(qubit,numGates,numReps);
			
			detune = qes.expParam(qubit,'f01');
			detune.offset = qubit.f01;
			
			XY2_amp = qes.expParam(qubit,'g_XY2_amp');
			XY2_amp.offset = qubit.g_XY2_amp;
			
			XY_amp = qes.expParam(qubit,'g_XY_amp');
			XY_amp.offset = qubit.g_XY_amp;
			
			alpha = qes.expParam(qubit,'qr_xy_dragAlpha');
			alpha.offset = 0.5;

			opts = optimset('Display','none','MaxIter',MAX_ITER,'TolX',0.001,'TolFun',0.01,'PlotFcns',{@optimplotfval});
			if isempty(qubit.g_XY_typ) || strcmp(qubit.g_XY_typ,'pi')
				f = qes.expFcn([detune,XY2_amp,XY_amp,alpha],R);
				optParams = qes.util.fminsearchbnd(f.fcn,...
					[0,0,],...
					[-2e6,-qubit.g_XY2_amp*0.05,-qubit.g_XY_amp*0.05,-0.25],...
					[2e6,qubit.g_XY2_amp*0.05,qubit.g_XY_amp*0.05,0.25],...
					opts);
			elseif strcmp(qubit.g_XY_typ,'hPi')
				f = qes.expFcn([detune,XY2_amp,alpha],R);
				optParams = qes.util.fminsearchbnd(f.fcn,...
					[0,0,0],...
					[-2e6,-qubit.g_XY2_amp*0.05,-0.25],...
					[2e6,qubit.g_XY2_amp*0.05,0.25],...
					opts);
			else
				error('unrecognized X gate type: %s, available x gate options are: pi and hPi',...
					qubit.g_XY_typ);
            end
            
            try
            timeStamp = datestr(now,'_yymmddTHHMMSS_');
            dataFileName = ['OPT_',timeStamp,'.mat'];
            figFileName = ['OPT_',timeStamp,'.fig'];
            saveas(gcf,figFileName);
            close(gcf);
            save(dataFileName,'optParams');
                catch
                end
		end
		function xyGateOptNoDrag(qubit,numGates,numReps)
            MAX_ITER = 20;
            
            
			import sqc.op.physical.*
			if ischar(qubit)
				qs = sqc.util.loadQubits();
				qubit = qs{qes.util.find(qubit,qs)};
			end
			if qubit.qr_xy_dragPulse
				error('DRAG enable, can not do no DRAG optimization, checking qubit settings.');
			end
			qubit.r_avg = rAvg;
			R = sqc.measure.randBenchMarking4Opt(qubit,numGates,numReps);
			
			detune = qes.expParam(qubit,'f01');
			detune.offset = qubit.f01;
			
			XY2_amp = qes.expParam(qubit,'g_XY2_amp');
			XY2_amp.offset = qubit.g_XY2_amp;
			
			XY_amp = qes.expParam(qubit,'g_XY_amp');
			XY_amp.offset = qubit.g_XY_amp;

			opts = optimset('Display','none','MaxIter',MAX_ITER,'TolX',0.001,'TolFun',0.01,'PlotFcns',{@optimplotfval});
			if isempty(qubit.g_XY_typ) || strcmp(qubit.g_XY_typ,'pi')
				f = qes.expFcn([detune,XY2_amp,XY_amp],R);
				optParams = qes.util.fminsearchbnd(f.fcn,...
                    [0,0,0],...
					[-2e6,-qubit.g_XY2_amp*0.05,-qubit.g_XY_amp*0.05],...
					[2e6,qubit.g_XY2_amp*0.05,qubit.g_XY_amp*0.05],...
					opts);
			elseif strcmp(qubit.g_XY_typ,'hPi')
				f = qes.expFcn([detune,XY2_amp],R);
				optParams = qes.util.fminsearchbnd(f.fcn,...
                    [0,0],...
					[-2e6, -qubit.g_XY2_amp*0.05],...
					[2e6, qubit.g_XY2_amp*0.05],...
					opts);
			else
				error('unrecognized X gate type: %s, available x gate options are: pi and hPi',...
					qubit.g_XY_typ);
            end
            
            
            try
            timeStamp = datestr(now,'_yymmddTHHMMSS_');
            dataFileName = ['OPT_',timeStamp,'.mat'];
            figFileName = ['OPT_',timeStamp,'.fig'];
            saveas(gcf,figFileName);
            close(gcf);
            save(dataFileName,'optParams');
                catch
                end
            
        end
        
        function czOptPhaseAmp(qubits,numGates,numReps, rAvg)
            MAX_ITER = 30;
            
            
			import sqc.op.physical.*
			if ~iscell(qubits) || numel(qubits) ~= 2
				error('qubits not a cell of 2.');
			end
			for ii = 1:numel(qubits)
				if ischar(qubits{ii})
					qs = sqc.util.loadQubits();
					qubits{ii} = qs{qes.util.find(qubits{ii},qs)};
                end
                qubits{ii}.r_avg = rAvg;
            end
            
			
			aczSettingsKey = sprintf('%s_%s',qubits{1}.name,qubits{2}.name);
			QS = qes.qSettings.GetInstance();
			scz = QS.loadSSettings({'shared','g_cz',aczSettingsKey});
			aczSettings = sqc.qobj.aczSettings();
			fn = fieldnames(scz);
			for ii = 1:numel(fn)
				aczSettings.(fn{ii}) = scz.(fn{ii});
			end
			qubits{1}.aczSettings = aczSettings;
			
			R = sqc.measure.randBenchMarking4Opt(qubits,numGates,numReps);
			
			phase1 = qes.expParam(aczSettings,'dynamicPhase(1)');
			phase1.offset = 0;
			
			phase2 = qes.expParam(aczSettings,'dynamicPhase(2)');
			phase2.offset = 0;
			
			amplitude = qes.expParam(aczSettings,'amp');
			amplitude.offset = aczSettings.amp;

			opts = optimset('Display','none','MaxIter',MAX_ITER,'TolX',0.001,'TolFun',0.01,'PlotFcns',{@optimplotfval});
			f = qes.expFcn([phase1,phase2,amplitude],R);
			optParams = qes.util.fminsearchbnd(f.fcn,...
                    [0,0,0],...
					[-pi,-pi,-aczSettings.amp*0.1],...
					[pi,pi,aczSettings.amp*0.1],...
					opts);
            
                try
            timeStamp = datestr(now,'_yymmddTHHMMSS_');
            dataFileName = ['OPT_',timeStamp,'.mat'];
            figFileName = ['OPT_',timeStamp,'.fig'];
            saveas(gcf,figFileName);
            close(gcf);
            save(dataFileName,'optParams');
                catch
                end
            
            
            
            
            
        end
        
    end
end