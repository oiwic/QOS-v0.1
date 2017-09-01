function varargout = Tomo_1QState_animation(varargin)
% demonstration of state tomography on single qubit.
% state tomography is a measurement, it is not used alone in real
% applications, this simple function is just a demonstration/test to show
% that state tomography is working properly.
% prepares a a state(options are: '|0>', '|1>','|0>+|1>','|0>-|1>','|0>+i|1>','|0>-i|1>')
% and do state tomography.
%
% <_o_> = Tomo_1QState('qubit',_c&o_,...
%       'state',<_c_>,'numPts',_i_,...
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

% Yulin Wu, 2017

    import qes.*
    import sqc.*
    import sqc.op.physical.*

    args = util.processArgs(varargin,{'state','|0>','notes','','save',true});
    q = data_taking.public.util.getQubits(args,{'qubit'});

    R = measure.stateTomography(q);
    
    isXhPi = false;
    switch args.state
        case {'|1>','|1>x'}
            if strcmp(q.g_XY_typ,'pi')
                p = gate.X(q);
            else
                p = gate.X2p(q);
                isXhPi = true;
            end
        case {'|1>y'}
            if strcmp(q.g_XY_typ,'pi')
                p = gate.Y(q);
            else
                p = gate.Y2p(q);
                isXhPi = true;
            end
        case '|0>+|1>'
            p = gate.Y2m(q);
        case '|0>-|1>'
            p = gate.Y2p(q);
        case '|0>+i|1>'
            p = gate.X2p(q);
        case '|0>-i|1>'
            p = gate.X2m(q);
        otherwise
            throw(MException('QOS_singleQStateTomo',...
                sprintf('available state options for singleQStateTomo is %s, %s given.',...
                '|0> |1> |0>+|1> |0>-|1> |0>+i|1> |0>-i|1>',args.state)));
    end
    R.setProcess(p);
    h = qes.ui.qosFigure(sprintf('State tomography | %s', q.name),false);
    ax = axes('parent',h);
    blochSphere = sqc.util.blochSphere(ax);
    blochSphere.drawHistory = true;
    blochSphere.showMenubar = true;
    blochSphere.showToolbar = true;
%     blochSphere.historyMarkerSize = 6;
    blochSphere.historyMarker = 'o';
    amps = linspace(0,p.amp,args.numPts);
    data = NaN(3,args.numPts);
    for ii = 1:args.numPts
        p.amp = amps(ii);
        if isXhPi
            R.setProcess(p*p);
        end
        P = R();
        data(:,ii) = P*[-1;1]; % {'Y2m','X2p','I'}
        blochSphere.addStateXYZ(data(1,ii),data(2,ii),data(3,ii),1,true);
        drawnow();
    end

    if args.save
        QS = qes.qSettings.GetInstance();
        dataPath = QS.loadSSettings('data_path');
        timeStamp = datestr(now,'_yymmddTHHMMSS_');
        dataFileName = ['STomo1_',q.name,timeStamp,'.mat'];
        figFileName = ['STomo1_',q.name,timeStamp,'.fig'];
        sessionSettings = QS.loadSSettings;
        hwSettings = QS.loadHwSettings;
        save(fullfile(dataPath,dataFileName),'data','args','sessionSettings','hwSettings');
        if isgraphics(ax)
            saveas(ax,fullfile(dataPath,figFileName));
        end
    end
    varargout{1} = data;
end