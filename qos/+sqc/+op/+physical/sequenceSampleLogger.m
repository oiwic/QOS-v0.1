classdef sequenceSampleLogger < handle
    properties (SetAccess = private, GetAccess = private)
        qubits = {};
        xySequenceSamples
        zSequenceSamples
    end
    methods
        function put(obj,qName, seq, isXY)
            ind = qes.util.find(qName, obj.qubits);
            if isempty(ind)
                obj.qubits{end+1} = qName;
                obj.xySequenceSamples{end+1} = [];
                obj.zSequenceSamples{end+1} = [];
                ind = length(obj.qubits);
            end
            if isXY
                obj.xySequenceSamples{ind} = seq.samples();
            else
                obj.zSequenceSamples{ind} = seq.samples();
            end
        end
        function [qubits, xySequenceSamples, zSequenceSamples] = get(obj)
            try
                sqc.op.physical.sequenceSampleLogger.sortQubits();
            catch
            end
            qubits = obj.qubits;
            xySequenceSamples = obj.xySequenceSamples;
            zSequenceSamples = obj.zSequenceSamples;
        end
    end
    methods (Access = private)
        function obj = sequenceSampleLogger()
        end
    end
    methods (Static)
        function obj = GetInstance()
            % qSettings is a global setting, if instance already exits, return the existing instance.
            persistent instance;
            if ~isempty(instance) &&  isvalid(instance)
                obj = instance;
                return;
			end
            instance = sqc.op.physical.sequenceSampleLogger();
            obj = instance;
        end
        function sortQubits()
            instance = sqc.op.physical.sequenceSampleLogger.GetInstance();
            numQs = numel(instance.qubits);
            qubitInd = nan(1,numQs);
            for ii = 1:numQs
                qubitInd(ii) = str2double(instance.qubits{ii}(2:end));
            end
            [~,ind] = sort(qubitInd);
            instance.qubits = instance.qubits(ind);
            instance.xySequenceSamples = instance.xySequenceSamples(ind);
            instance.zSequenceSamples = instance.zSequenceSamples(ind);
        end
        function axs = plot(axs)
            instance = sqc.op.physical.sequenceSampleLogger.GetInstance();
            numQs = numel(instance.qubits);
            try
                sqc.op.physical.sequenceSampleLogger.sortQubits();
            catch
            end
            if nargin < 2
                h = qes.ui.qosFigure('Seq. samples',false);
                axH = 0.9/numQs;
                v = 0.075;
                for ii = 1:numQs
                    axs(ii) = axes('parent',h,'Position',[0.075,v,0.9,axH],'Visible','off');
                    v = v + axH;
                end
            elseif numel(axs) < numQs
                error('number of axes not equal to number of qubits');
            end
            linkaxes(axs,'xy');
            length = 0;
            amp = 0;
            for ii = 1:numQs
                hold(axs(ii),'on');
                if ~isempty(instance.xySequenceSamples{ii})
                    plot(axs(ii),instance.xySequenceSamples{ii}(1,:),'Color',qes.ui.randSColor(),'LineWidth',1);
                    plot(axs(ii),instance.xySequenceSamples{ii}(2,:),'Color',qes.ui.randSColor(),'LineWidth',1);
                    length = max(length, size(instance.xySequenceSamples{ii},2));
                    amp = max(amp,max(instance.xySequenceSamples{ii}(1,:)));
                    amp = max(amp,max(instance.xySequenceSamples{ii}(2,:)));
                end
                if ~isempty(instance.zSequenceSamples{ii})
                    plot(axs(ii),instance.zSequenceSamples{ii}(1,:),'Color',qes.ui.randSColor(),'LineWidth',1);
                    length = max(length, size(instance.zSequenceSamples{ii},2));
                    amp = max(amp,max(instance.zSequenceSamples{ii}(1,:)));
                end
                ylabel(axs(ii),instance.qubits{ii});
            end
            set(axs(1),'XLim',[1,length+1],'YLim',1.1*[-amp,amp]);
        end
    end
end