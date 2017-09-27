function [fidelity,h] = randBenchMarking(numGates, Pref, Pgate, numQs, gateName,ax)

    numGates = double(numGates); % numGates could be int16

    if nargin < 5
        gateName = '';
    end
    if nargin < 6
        ax = [];
    end

    function y_ = fitFcn(p,x_)
        y_ = p(1)*p(2).^x_+p(3);
    end
    p0(1) = range(Pref);
    p0(2) = 1-0.02*2^numQs/(2^numQs-1);
    p0(3) = Pref(end);
    lb = [0.8*p0(1),1-0.7*2^numQs/(2^numQs-1),0];
    ub = [5*p0(1),1,1.1*p0(3)];
    [Cref,~,res_ref,~,~,~,J_ref] = lsqcurvefit(@fitFcn,p0,numGates(:),Pref(:),lb,ub);
    
    p0(1) = range(Pgate);
    p0(2) = 1-0.02*2^numQs/(2^numQs-1);
    p0(3) = Pgate(end);
    lb = [0.8*p0(1),1-0.7*2^numQs/(2^numQs-1),0];
    ub = [5*p0(1),1,1.1*p0(3)];
    [Cgate,~,res_ref,~,~,~,J_ref] = lsqcurvefit(@fitFcn,p0,numGates(:),Pgate(:),lb,ub);
    
    rref = (1-Cref(2))*(2^numQs-1)/(2^numQs);
    rgate = (1-Cgate(2))*(2^numQs-1)/(2^numQs);
    fidelity = 1-(1-Cgate(2)/Cref(2))*(2^numQs-1)/(2^numQs);
    
    if isempty(ax) || ~isgraphics(ax)
        h = qes.ui.qosFigure(sprintf('Randomized Benchmarking | %s', gateName),false);
        ax = axes('parent',h,'FontSize',16);
    else
        axes(ax);
        h = gcf;
        hold(ax,'on');
    end
    
    plot(ax,numGates,Pref,'.b','MarkerSize',8);
    hold on;
    plot(ax,numGates,Pgate,'.r','MarkerSize',8);
    xlabel(ax,'number of Clifford gates','FontSize',12);
    ylabel(ax,'sequence fidelity','FontSize',16);
    legend(ax,{'reference',[gateName, ' interleaved']},'FontSize',12);
    
%     if numGates == 1
%         title(ax,[gateName,' fidelity: ',num2str(fidelity,'%0.4f'),...
%             ', r_{SQ,ref}: ',num2str(rref/1.875,'%0.4f'),', r_{SQ,gate}: ',num2str(rgate/1.875,'%0.4f')],...
%             'FontSize',12,'FontWeight','normal','interpreter','tex');
%     else
%     end
    
    title(ax,[gateName,' fidelity: ',num2str(fidelity,'%0.4f'),...
        ', r_{ref}: ',num2str(rref,'%0.4f'),', r_{interleaved}: ',num2str(rgate,'%0.4f')],...
        'FontSize',12,'FontWeight','normal','interpreter','tex');
    
    xf = 0.5:0.1:1*numGates(end)+0.5;
    plot(ax,xf,fitFcn(Cref,xf),'-b','LineWidth',1);
    plot(ax,xf,fitFcn(Cgate,xf),'-r','LineWidth',1);
    grid on;
end