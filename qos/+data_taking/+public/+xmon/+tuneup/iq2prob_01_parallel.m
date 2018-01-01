function varargout = iq2prob_01_multiplexed(varargin)
% iq2prob_01: calibrate iq to qubit state probability, |0> and |1>
% 
% <[_f_]> = iq2prob_01_multiplexed('qubits',[_c&o_],'numSamples',_i_,...
%       'gui',<_b_>,'save',<_b_>)
% _f_: float
% _i_: integer
% _c_: char or char string
% _b_: boolean
% _o_: object
% a&b: default type is a, but type b is also acceptable
% []: can be an array, scalar also acceptable
% {}: must be a cell array
% <>: optional, for input arguments, assume the default value if not specified
% arguments order not important as long as the form correct pairs.
% Yulin Wu, 2017

    import qes.*
    import sqc.*
    import sqc.op.physical.*
	
	numSamples_MIN = 1e4;
	
	args = util.processArgs(varargin,{'gui',false,'save',true});
	qubits = args.qubits;
	if ~iscell(qubits)
		qubits = {qubits};
	end
	
	numQs = numel(qubits);
	Xs = cell(1,numQs);
	RDelay = 0;
    for ii = 1:numQs
        if ischar(qubits{ii})
            qubits{ii} = sqc.util.qName2Obj(qubits{ii});
        end
		qubits{ii}.r_avg = args.numSamples;
		Xs{ii} = gate.X(qubits{ii});
		RDelay = max(RDelay,Xs{ii}.length);
    end

    if args.numSamples < numSamples_MIN
        throw(MException('QOS_iq2prob_01:numSamplesTooSmall',...
			sprintf('numSamples too small, %0.0f minimu.', numSamples_MIN)));
    end
	
    R = measure.resonatorReadout(qubits);
    R.delay = RDelay; 
    
    for jj = 1:numQs
		Xs{jj}.Run();
	end
    R.Run();
    iq_raw_1 = R.extradata;
	R.Run();
    iq_raw_0 = R.extradata;

	for ii = 1:numQs
	q = qubits{ii};
    [center0, center1,F00,F11, hf] =... 
		data_taking.public.dataproc.iq2prob_centers(iq_raw_0(ii,:),iq_raw_1(ii,:),~args.gui);

    if ischar(args.save)
        args.save = false;
        choice  = questdlg('Update settings?','Save options',...
                'Yes','No','No');
        if ~isempty(choice) && strcmp(choice, 'Yes')
            args.save = true;
        end
    end
    if args.save
        QS = qes.qSettings.GetInstance();
		QS.saveSSettings({q.name,'r_iq2prob_center0'},center0);
        QS.saveSSettings({q.name,'r_iq2prob_center1'},center1);
		QS.saveSSettings({q.name,'r_iq2prob_fidelity'},...
			sprintf('[%0.3f,%0.3f]',F00,F11));
        % QS.saveSSettings({q.name,'r_iq2prob_01rPoint'},rPoint);
        % QS.saveSSettings({q.name,'r_iq2prob_01angle'},ang);
        % QS.saveSSettings({q.name,'r_iq2prob_01threshold'},threshold);
        % QS.saveSSettings({q.name,'r_iq2prob_01polarity'},num2str(polarity,'%0.0f'));
        if ~isempty(hf) && isvalid(hf)
            dataSvName = fullfile(QS.loadSSettings('data_path'),...
                ['iqRaw_',q.name,'_',datestr(now,'yymmddTHHMMSS'),...
                num2str(ceil(99*rand(1,1)),'%0.0f'),'_.fig']);
            saveas(hf,dataSvName);
        end
    end
	end

	varargout{1} = [];
end