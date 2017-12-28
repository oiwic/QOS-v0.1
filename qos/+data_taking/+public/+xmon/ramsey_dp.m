function varargout = ramsey_dp(varargin)
% ramsey: ramsey oscillation,..
% detune by changing the second pi/2 pulse tracking frame
% 
% <_o_> = ramsey_dp('qubit',_c&o_,...
%       'time',[_i_],'detuning',<[_f_]>,'phaseOffset',<_f_>,...
%       'dataTyp',<'_c_'>,...   % S21, P or Phase
%       'notes',<_c_>,'gui',<_b_>,'save',<_b_>)
% _f_: float
% _i_: integer
% _c_: char or char string
% _b_: boolean
% _o_: object
% a&b: default type is a, but type b is also acceptable
% []: can be an array, scalar also acceptable
% {}: must be a cell array
% <>: optional, for input arguments, assume the default value if not specified
% arguments order not important as long as they form correct pairs.

% Yulin Wu, 2016/12/27

    fcn_name = 'data_taking.public.xmon.ramsey_dp'; % this and args will be saved with data
    import qes.*
    import sqc.*
    import sqc.op.physical.*

    args = util.processArgs(varargin,{'phaseOffset',0,'dataTyp','P',...
        'gui',false,'notes','','detuning',0,'save',true});
    q = data_taking.public.util.getQubits(args,{'qubit'});

    X2 = op.XY2(q,pi/2+args.phaseOffset);
    X2_ = op.XY2(q,-pi/2);
    I = gate.I(q);
    
%     I = op.detune(q);
%     I.df = 3e4;
    
    Z = op.Z_arbPhase(q,args.phaseOffset);

    isPhase = false;
    switch args.dataTyp
        case 'P'
            R = measure.resonatorReadout_ss(q);
            R.state = 2;
        case 'S21'
            R = measure.resonatorReadout_ss(q);
            R.swapdata = true;
            R.name = 'iq';
            R.datafcn = @(x)mean(abs(x));
        case 'Phase'
            R = measure.phase(q);
            isPhase = true;
        otherwise
            throw(MException('QOS_ramsey_dp:unrcognizedDataTyp',...
            'unrecognized dataTyp %s, available dataTyp options are P, S21 or Phase.', args.dataTyp));
    end

	detuning = qes.util.hvar(0);
	da = qHandle.FindByClassProp('qes.hwdriver.hardware','name',...
		q.channels.xy_i.instru);
	daChnl = da.GetChnl(q.channels.xy_i.chnl);
	daSamplingRate = daChnl.samplingRate;

    function procFactory(delay)
        I.ln = delay;
        phase = 2*pi*detuning.val*delay/daSamplingRate+args.phaseOffset;
        if isPhase
            Z.phase = phase;
            proc = X2_*I*Z;
            R.setProcess(proc);
        else
            proc = X2_*I*X2;
            X2.phi = -phase;
            proc.Run();
            R.delay = proc.length;
        end
    end

    x = expParam(detuning,'val');
	x.name = [q.name,' detuning(Hz)'];
    y = expParam(@procFactory);
    y.name = [q.name,' time'];
	s1 = sweep(x);
    s1.vals = args.detuning;
    s2 = sweep(y);
    s2.vals = args.time;
    e = experiment();
    e.name = 'Ramsey(Detune by Phase)';
    e.sweeps = [s1,s2];
    e.measurements = R;
    e.datafileprefix = sprintf('%s', q.name);
    if ~args.gui
        e.showctrlpanel = false;
        e.plotdata = false;
    end
    if ~args.save
        e.savedata = false;
    end
    e.notes = args.notes;
    e.addSettings({'fcn','args'},{fcn_name,args});
    e.Run();
    varargout{1} = e;
end