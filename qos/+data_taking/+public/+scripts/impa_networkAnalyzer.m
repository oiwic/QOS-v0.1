% impa bring up with network analyzer
%% initialization
disp('Initializing...');
import qes.*
import data_taking.public.jpa.*

cd('F:\program\QOS\qos'); 
% addpath('F:\program\QOS\qos\dlls');

QS = qSettings.GetInstance('F:\program\QOS\qos_settings');
QS.SU('yulin');
QS.SS('impa_170220');
QS.CreateHw();

disp('Initialization done.');
signalCenter = 6.6744e9;
%%
% <_o_> = s21_BiasPwrpPwrs_networkAnalyzer('jpaName',_c&o_,...
%       'startFreq',_f_,'stopFreq',_f_,...
%       'numFreqPts',_i_,'avgcounts',_i_,...
%       'NAPower',_f_,'bandwidth',_f_,...
%       'pumpFreq',[_f_],'pumpPower',[_f_],...
%       'bias',[_f_],...
%       'notes',<[_c_]>,'gui',<_b_>,'save',<_b_>)
% _f_: float
% _i_: integer
% _c_: char or char string
% _b_: boolean
% _o_: object
% a&b: default type is a, but type b is also acceptable
% []: can be an array, scalar also acceptable
% {}: must be a cell array
% <>: optional, for input arguments, assume the default value if not specified
% arguments order not important as long as the form correct pairs.
%% scan s21-bias,signal frequency
data=s21_BiasPwrpPwrs_networkAnalyzer('jpaName','impa1',...
       'startFreq',4e9,'stopFreq',8e9,...
       'numFreqPts',200,'avgcounts',20,...
       'NAPower',-20,'bandwidth',3e3,...
       'pumpFreq',2*signalCenter,'pumpPower',-120,...
       'bias',-1e-3:10e-6:1e-3,...
       'notes','na 40dB @ Room Temperature','gui',true,'save',true);
%% 
delt=1.05;
if exist('Data','var') && numel(Data)==1 % Analyse loaded data
    Data = Data{1,1};
    bias = SweepVals{1,1}{1,1};
    freqs = Data{1,1}(2,:);
else % Analyse fresh data
    Data = data.data{1};
    bias = data.sweepvals{1,1}{1,1};
    freqs = Data{1,1}(2,:);
end
meshdata=NaN(numel(bias),numel(freqs));
for II=1:numel(bias)
    meshdata(II,:)=Data{II,1}(1,:);
end
ANG=unwrap(angle(meshdata'));
figure(11);imagesc(bias,freqs,abs(meshdata'));  set(gca,'ydir','normal');xlabel('JPA bias');ylabel('Freq'); title('|S21|')
slop=(mean(ANG(end,:))-mean(ANG(1,:)))/(freqs(end)-freqs(1))*delt;
slops=meshgrid(slop*(freqs-freqs(1)),ones(1,numel(bias)))';
ANGS=mod(ANG-slops-(ANG(1,end))+pi,2*pi);
figure(12);imagesc(bias,freqs,ANGS);  set(gca,'ydir','normal');xlabel('JPA bias');ylabel('Freq');colorbar;title('unwraped phase')

%% scan s21-pump power,signal frequency
s21_BiasPwrpPwrs_networkAnalyzer('jpaName','impa1',...
       'startFreq',6.45e9,'stopFreq',6.9e9,...
       'numFreqPts',100,'avgcounts',10,...
       'NAPower',-10,'bandwidth',3e3,...
       'pumpFreq',2*signalCenter,'pumpPower',-2:0.1:1,...
       'bias',0.228e-3,...
       'notes','na 40dB @ Room Temperature','gui',true,'save',true)
%% scan s21-pump power,signal frequency,bias
for bias = 0.150e-3:0.02e-3:0.250e-3
s21_BiasPwrpPwrs_networkAnalyzer('jpaName','impa1',...
       'startFreq',6.45e9,'stopFreq',6.9e9,...
       'numFreqPts',500,'avgcounts',50,...
       'NAPower',-10,'bandwidth',3e3,...
       'pumpFreq',2*signalCenter,'pumpPower',[-120,-2:0.05:1],...
       'bias',bias,...
       'notes','na 40dB @ Room Temperature','gui',false,'save',true)
end
%% scan s21-pump frequency,signal frequency
s21_BiasPwrpPwrs_networkAnalyzer('jpaName','impa1',...
       'startFreq',6.45e9,'stopFreq',6.9e9,...
       'numFreqPts',100,'avgcounts',10,...
       'NAPower',-10,'bandwidth',3e3,...
       'pumpFreq',2*(linspace(6.45e9,6.9e9,100)),'pumpPower',-1.6,...
       'bias',0.2e-3,...
       'notes','na 40dB @ Room Temperature','gui',true,'save',true)
%% scan s21(Noise)-signal frequency
s21_BiasPwrpPwrs_networkAnalyzer('jpaName','impa1',...
       'startFreq',6.45e9,'stopFreq',6.9e9,...
       'numFreqPts',200,'avgcounts',5,...
       'NAPower',-10,'bandwidth',3e3,...
       'pumpFreq',2*signalCenter,'pumpPower',-0.5*ones(1,1000),...
       'bias',0.228e-3,...
       'notes','na 40dB @ Room Temperature','gui',true,'save',true)