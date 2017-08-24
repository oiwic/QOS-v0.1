function g = Y(qubit)
	% Y
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com
	import sqc.op.physical.gate.*
	switch qubit.g_XY_typ
		case 'pi' % implement Y
			g = Y_(qubit);
		case 'hPi' % implement by using Y2p*Y2p gates
			g = Y2p(qubit)*Y2p(qubit);
            g.setGateClass('Y');
		otherwise
			error('unrecognized X gate type: %s, available x gate options are: pi and hPi',...
				qubit.g_Z_typ);
	
	end
end
