function varargout = acz_ampLength(varargin)
% <_o_> = acz_ampLength('controlQ',_c&o_,'targetQ',_c&o_,...
%       'czLength',[_i_],'czAmp',[_f_],'cState','0',...
%       'dataTyp',<_c_>,...  % options: P, or Phase
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

% Yulin Wu, 2017/7/2

    fcn_name = 'data_taking.public.xmon.acz_ampLength'; % this and args will be saved with data
    import qes.*
    import sqc.*
    import sqc.op.physical.*

    args = util.processArgs(varargin,{'cState','0','gui',false,'notes','','save',true});
    [qc,qt] = data_taking.public.util.getQubits(args,{'controlQ','targetQ'});

    
    if args.cState == '0'
        X = gate.I(qc);
    else
        X = gate.X(qc);
    end
    Ip = gate.I(qt);
    Ip.ln = X.length;
            
    Y2m = gate.Y2m(qt);
    Y2p = gate.Y2p(qt);
    % H = gate.
    CZ = gate.CZ(qc,qt);

    isPhase = false;
    switch args.dataTyp
        case 'P'
            R = measure.resonatorReadout_ss(qt);
            R.state = 2;
        case 'Phase'
            R = measure.phase(qt);
            isPhase = true;
        otherwise
            throw(MException('QOS_ramsey_dp:unrcognizedDataTyp',...
            'unrecognized dataTyp %s, available dataTyp options are P, S21 or Phase.', args.dataTyp));
    end

    czLength = qes.util.hvar(0);
    function procFactory(amp)
        CZ.aczLn = czLength.val;
        CZ.amp = amp;
        % proc = (X.*Y2m)*Id*CZ*Id*Y2p;
        if isPhase
            proc = ((X.*Ip)*Y2m)*CZ;  % CNOT
            R.setProcess(proc);
        else
            proc = ((X.*Ip)*Y2m)*CZ*Y2p;  % CNOT
            proc.Run();
            R.delay = proc.length;
        end
    end

    x = expParam(czLength,'val');
	x.name = ['CZ[',qc.name,',', qt.name,'] length'];
    
    y = expParam(@procFactory);
    y.name = ['CZ[',qc.name,',', qt.name,'] amplitude'];
    s1 = sweep(x);
    s1.vals = args.czLength;
    s2 = sweep(y);
    s2.vals = args.czAmp;
    e = experiment();
    e.name = 'ACZ amplitude';
    e.sweeps = [s1,s2];
    e.measurements = R;
    e.datafileprefix = sprintf('CZ%s%s', qc.name,qt.name);
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