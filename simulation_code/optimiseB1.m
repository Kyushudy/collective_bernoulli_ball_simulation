tic;
close all;

poolobj = parpool('LocalProfile1');

load('3DRealWorldData.mat');

% % reference data from real world experiments
% b1x = T_22_3(:,1);
% b1y = T_22_3(:,2);
% b1z = T_22_3(:,3);

% % a*-
% b1x = T_20_3(:,1);
% b1y = T_20_3(:,2);
% b1z = T_20_3(:,3);

% a*--
b1x = T_18_3(:,1);
b1y = T_18_3(:,2);
b1z = T_18_3(:,3);

meanZ = mean(b1z);
varZ = var(b1z);
varXY = (var(b1x) + var(b1y))/2;
realworlddata = [meanZ varZ varXY];

%Define cost function
costFcn = @(x)sim_1balloon(x, realworlddata);

%Define bounds of variables
nVB = [0 0.03]; %Noise vertical
nHB = [0 0.03]; %Noise Horizontal
nSB = [0.05 0.1]; %Sample time of noise
V0B = [0 5]; %Outlet velocity
normalScalingB = [0.25 1]; %Flow scaling
hdB = [0 0.05]; %damping coefficient of velocity
thetaB = [1 10]; %nozzle angles (degrees)

%Create
% nV = optimizableVariable('nV',nVB);
% nH = optimizableVariable('nH',nHB);
% nS = optimizableVariable('nS',nSB);
V0 = optimizableVariable('V0',V0B);
% normalScaling = optimizableVariable('normalScaling',normalScalingB);
% hd = optimizableVariable('hd',hdB);
% theta  = optimizableVariable('theta',thetaB);
% 
% %optimisation c, c`
% results = bayesopt(costFcn,[nV, nH, nS, V0, normalScaling, hd, theta]...
%     ,'MaxObjectiveEvaluations',1000,'AcquisitionFunctionName',...
%     'expected-improvement','UseParallel',1,'IsObjectiveDeterministic' ,0,'NumSeedPoints',50);

% %inheritance a, a`
% results = bayesopt(costFcn,[V0, normalScaling, hd, theta]...
%     ,'MaxObjectiveEvaluations',100,'AcquisitionFunctionName',...
%     'expected-improvement','UseParallel',1,'IsObjectiveDeterministic' ,0,'NumSeedPoints',50);

%inheritance a`- a`--
results = bayesopt(costFcn,[V0]...
    ,'MaxObjectiveEvaluations',100,'AcquisitionFunctionName',...
    'expected-improvement','UseParallel',1,'IsObjectiveDeterministic' ,0,'NumSeedPoints',50);


% %inheritance b
% results = bayesopt(costFcn,[nV, nH, nS]...
%     ,'MaxObjectiveEvaluations',100,'AcquisitionFunctionName',...
%     'expected-improvement','UseParallel',1,'IsObjectiveDeterministic' ,0,'NumSeedPoints',50);


%% Simulate result

x=results.XAtMinObjective;
delete(poolobj);
toc;

