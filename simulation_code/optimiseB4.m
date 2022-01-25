tic;
close all;

poolobj = parpool('LocalProfile1');

load('3DRealWorldData.mat');
load('coefficient_dragq.mat', 'coefficient_dragq');
load('coefficient_sideforceq.mat', 'coefficient_sideforceq');

% reference data from real world experiments
b1x = T_22_3333(:,1);
b1y = T_22_3333(:,2);
b1z = T_22_3333(:,3);
b2x = T_22_3333(:,4);
b2y = T_22_3333(:,5);
b2z = T_22_3333(:,6);
b3x = T_22_3333(:,7);
b3y = T_22_3333(:,8);
b3z = T_22_3333(:,9);
b4x = T_22_3333(:,10);
b4y = T_22_3333(:,11);
b4z = T_22_3333(:,12);
meanZ = (mean(b1z) + mean(b2z) + mean(b3z) + mean(b4z))/4;
varZ = (var(b1z) + var(b2z) + var(b3z) + var(b4z))/4;
varXY = (var(b1x) + var(b1y) + var(b2x) + var(b2y) + ...
    var(b3x) + var(b3y) + var(b4x) + var(b4y))/8;
realworlddata = [meanZ varZ varXY];

%Define cost function
costFcn = @(x)sim_4balloon(x, realworlddata, coefficient_dragq, coefficient_sideforceq);

%Define bounds of variables
nVB = [0 0.03]; %Noise vertical
nHB = [0 0.03]; %Noise Horizontal
nSB = [0.05 0.1]; %Sample time of noise
V0B = [1 5]; %Outlet velocity
normalScalingB = [0.25 1]; %Flow scaling
hdB = [0 0.05]; %damping coefficient of velocity
thetaB = [1 10]; %nozzle angles (degrees)
kB = [0.5e7 1.5e7]; %stiffness constant
dB = [10 1000]; %damping constant of contact force
twB = [0.5e-4 1.5e-4]; % Transition region width

%Create
nV = optimizableVariable('nV',nVB);
nH = optimizableVariable('nH',nHB);
nS = optimizableVariable('nS',nSB);
V0 = optimizableVariable('V0',V0B);
normalScaling = optimizableVariable('normalScaling',normalScalingB);
hd = optimizableVariable('hd',hdB);
theta  = optimizableVariable('theta',thetaB);
k  = optimizableVariable('k',kB);
d  = optimizableVariable('d',dB);
tw  = optimizableVariable('tw',twB);

% % m l l`
% results = bayesopt(costFcn,[nV, nH, nS, V0, normalScaling, hd, theta, k, d, tw]...
%     ,'MaxObjectiveEvaluations',100,'AcquisitionFunctionName',...
%     'expected-improvement','UseParallel',1,'IsObjectiveDeterministic' ,0,'NumSeedPoints',50);

% k
results = bayesopt(costFcn,[nV, nH, nS]...
    ,'MaxObjectiveEvaluations',100,'AcquisitionFunctionName',...
    'expected-improvement','UseParallel',1,'IsObjectiveDeterministic' ,0,'NumSeedPoints',50);


%% Simulate result

x=results.XAtMinObjective;
delete(poolobj);
toc;

