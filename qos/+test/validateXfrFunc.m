%% validate Numeric XfrFunc
frequency = linspace(-0.6,0.6,100);
ampRe = exp(-frequency.^2/0.2);
figure();plot(frequency,ampRe,'-+');

xfrFunc = com.qos.waveform.XfrFuncNumeric(frequency,ampRe,0*ampRe);
freq1 = linspace(-0.5,0.5,200);
ampE = xfrFunc.eval(freq1);
hold on;
plot(freq1,ampE(1:2:end),'-+');
