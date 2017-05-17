addpath('../FW-T/func');
addpath('../FW-T/PROPACK');
warning off;

data = 'mall';
% 'mall'
% 'lobby'
% 'hall'

delta = 1e-3;
rho = 1;  % sampling ratio; e.g. "1" for full observation

fprintf('**************************************************************\n')
fprintf(strcat(data, ' experiment', ' has started! \n'))
path = strcat('..\FW-T\data\',data,'.mat');
load(path); 
[m n] = size(D); 
fprintf('data has been loaded: m = %d, n = %d; \n', m,n);

%% parameter tuning

if rho == 1
    
    fprintf('RPCA with full obseravation; \n');
    obs = D; Omega = ones(m,n);
    
else
    
    fprintf('RPCA with partial obseravation: ');
    Omega = rand(m,n)<=rho; % support of observation
    obs = Omega.*D; % measurements are made
    fprintf('observations are generated; \n');
    
end

% this is parameter to control noise level
% the smaller the noise, the smaller is delta
obs = obs/norm(obs, 'fro');
lambda_1 = delta*rho; 
lambda_2 = delta*sqrt(rho)/sqrt(max(m,n));

% display video or not
showvideo = 1;

par.M = obs; 
par.lambda_1 = lambda_1; par.lambda_2 =lambda_2;
par.iter = 1000; 
par.epsilon = 10^-3; % stopping criterion
par.Omega = Omega;
par.showvideo = true; 
par.framesize = frameSize;

fprintf('**************************************************************\n')
fprintf('Let us try FW-T method! \n');
fprintf('**************************************************************\n')

output_fw = FW_T(par); % main function

% obtain the objective value returned from FW-T
L = output_fw.L; S = output_fw.S;




