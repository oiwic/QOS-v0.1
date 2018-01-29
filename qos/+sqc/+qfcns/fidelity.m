function f = fidelity(rho, sigma)
% state fidelity, rho, sigma are density matrixes

% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

%     % I
% 	r = sqrtm(rho);
% 	f = trace(sqrtm(r*sigma*r));

    
    % II
    m = rho*sigma;
    f = trace(m);
    f = sqrt(real(f));
    
end