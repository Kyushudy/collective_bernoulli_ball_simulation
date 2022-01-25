tic;
close all;

poolobj = parpool('LocalProfile1');

load('3DRealWorldData.mat');
load('coefficient_dragq.mat', 'coefficient_dragq');
load('coefficient_sideforceq.mat', 'coefficient_sideforceq');

% reference data from real world experiments
b1x = T_22_33(:,1);
b1y = T_22_33(:,2);
b1z = T_22_33(:,3);
b2x = T_22_33(:,4);
b2y = T_22_33(:,5);
b2z = T_22_33(:,6);
meanZ = (mean(b1z) + mean(b2z))/2;
varZ = (var(b1z) + var(b2z))/2;
varXY = (var(b1x) + var(b1y) + var(b2x) + var(b2y))/4;
realworlddata = [meanZ varZ varXY];

%Define cost function
costFcn = @(x)sim_2balloon(x, realworlddata, coefficient_dragq, coefficient_sideforceq);

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

% f i i`
results = bayesopt(costFcn,[nV, nH, nS, V0, normalScaling, hd, theta, k, d, tw]...
    ,'MaxObjectiveEvaluations',100,'AcquisitionFunctionName',...
    'expected-improvement','UseParallel',1,'IsObjectiveDeterministic' ,0,'NumSeedPoints',50);

% % e h
% results = bayesopt(costFcn,[nV, nH, nS, k, d, tw]...
%     ,'MaxObjectiveEvaluations',100,'AcquisitionFunctionName',...
%     'expected-improvement','UseParallel',1,'IsObjectiveDeterministic' ,0,'NumSeedPoints',50);

% % d g
% results = bayesopt(costFcn,[k, d, tw]...
%     ,'MaxObjectiveEvaluations',100,'AcquisitionFunctionName',...
%     'expected-improvement','UseParallel',1,'IsObjectiveDeterministic' ,0,'NumSeedPoints',50);


%% Simulate result

x=results.XAtMinObjective;
delete(poolobj);
toc;

