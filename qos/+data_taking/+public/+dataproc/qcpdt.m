function P = qcpdt(P,rA)
	count = 0;
    while any(P < 0)
        ind = P < 0;
        P(~ind) = P(~ind) + sum(P(ind))/sum(~ind);
		if count > 3
			rA = rA/2;
		end
		if count > 10
			break;
		end
        r = rA*rand(1,sum(ind));
        count = 0;
        for ii = 1:numel(P)
            if ind(ii)
                count  = count + 1;
                P(ii) = r(count);
            end
        end
        P(~ind) = P(~ind) - sum(r)/sum(~ind);
		count = count + 1;
    end
end