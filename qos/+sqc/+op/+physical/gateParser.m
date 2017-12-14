classdef gateParser
    % parse quantum circuit as gate name matrix:
    % qubits = {'q1','q2','q3'};
    % gateMat = {'Y2p','Y2m','I';
    %             'CZ','CZ','I';
    %             'I','Y2p','I';
    %             'I','I','Y2m';
    %             'I','CZ','CZ';
    %             'I','I','Y2p'};
    % p = gateParser.parse(qubits,gateMat);
    % p.Run; % creates a 3-Q GHZ state

% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

    methods (Static  = true)
        function g = parse(qubits,gateMat)
            if ~iscell(qubits)
                qubits = {qubits};
            end
            numQs = numel(qubits);
            matSz = size(gateMat);
            assert(numQs == matSz(2),'lenght of the second dimmension of gateMat not equal to the number of qubits');
            for ii = 1:numQs
                if ischar(qubits{ii})
                    qubits{ii} = sqc.util.qName2Obj(qubits{ii});
				end
            end
            supportedGates = sqc.op.physical.gateParser.supportedGates();
            g = sqc.op.physical.op.Z_arbPhase(qubits{1},0);
            for ii = 1:matSz(1)
                g_ = sqc.op.physical.op.Z_arbPhase(qubits{1},0);
                jj = 1;
                while jj <= numQs
                    if strcmp(gateMat{ii,jj},'I')
                        jj = jj+1;
                        continue;
                    end
                    if strcmp(gateMat{ii,jj},'CZ')
                        if jj == numQs || ~strcmp(gateMat{ii,jj+1},'CZ')
                            error('invalid gateMat: at least one CZ without a neibouring CZ');
                        end
                        try
                            g__ = sqc.op.physical.gate.CZ(qubits{jj},qubits{jj+1});
                        catch
                            g__ = sqc.op.physical.gate.CZ(qubits{jj+1},qubits{jj});
                        end
                        jj = jj + 1;
                    else
                        if ~ismember(gateMat{ii,jj},supportedGates)
                            error(['unsupported gate: ', gateMat{ii,jj}]);
                        end
                        g__ = feval(str2func(['@(q)sqc.op.physical.gate.',gateMat{ii,jj},'(q)']),qubits{jj});
                    end
                    g_ = g_.*g__;
                    jj = jj + 1;
                end
                g = g*g_;
            end
        end
        function gates = supportedGates()
            gates = {'I','H',...
                'X','X2p','X2m',...
                'Y','Y2p','Y2m',...
                'Z','Z2p','Z2m','Z4p','Z4m','S','Sd',...
                'CZ'
                };
        end
    end
    
end