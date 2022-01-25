function [e] = sim_4balloon_test(x, realworlddata, coefficient_dragq, coefficient_sideforceq)
tic;

% % j
% x = [1.873147e-03  4.449649e-04  5.948637e-02  2.153211e+00  7.063997e-01  4.829856e-02  7.430003e+00  1.362010e+07  1.831135e+02  1.271078e-04];
% % Random seed
% seedX1 = randi(100000);
% seedY1 = randi(100000);
% seedZ1 = randi(100000);
% seedX2 = randi(100000);
% seedY2 = randi(100000);
% seedZ2 = randi(100000);
% seedX3 = randi(100000);
% seedY3 = randi(100000);
% seedZ3 = randi(100000);
% seedX4 = randi(100000);
% seedY4 = randi(100000);
% seedZ4 = randi(100000);

% % k
% x = [4.146210e-03  2.702534e-04  7.766132e-02  2.153211e+00  7.063997e-01  4.829856e-02  7.430003e+00  1.362010e+07  1.831135e+02  1.271078e-04  9.383000e+04  4.320900e+04  8.951200e+04  3.987900e+04  8.149200e+04  4.025000e+03  3.390000e+04  4.921100e+04  3.947200e+04  9.079800e+04  8.836700e+04  7.394200e+04  2.962481e-01  3.289996e-01  1.037889e-01  2.430122e-01];

% % l
% x = [1.948899e-02  3.863078e-04  8.567043e-02  2.239593e+00  9.698210e-01  4.884375e-02  9.027468e+00  8.852942e+06  9.864721e+02  1.472130e-04  8.820000e+03  2.759200e+04  7.548900e+04  5.243700e+04  3.908500e+04  9.276200e+04  1.214700e+04  8.952600e+04  5.355000e+04  6.169400e+04  9.521100e+04  9.225600e+04  6.986309e-02  1.363536e+00  3.735217e-02  4.902503e-01];

% l`
x = [8.754915e-03  1.374086e-03  7.202835e-02  1.415826e+00  9.928982e-01  3.311548e-02  5.804839e+00  5.705938e+06  7.319541e+02  8.046658e-05  9.319000e+04  9.757100e+04  2.911600e+04  3.548500e+04  3.177100e+04  7.257500e+04  7.963900e+04  5.395500e+04  2.106600e+04  8.521300e+04  1.828400e+04  1.173300e+04  2.684412e-02  2.504031e-01  9.628613e-02  1.245111e-01];
% 
% % l`-
% x(4) = x(4) * 0.64646220;
% 
% % l`--
% x(4) = x(4) * 0.37442065;

% % m
% x = [2.540796e-02  2.651282e-03  6.186731e-02  1.201336e+00  9.782694e-01  3.916650e-02  3.685949e+00  1.141374e+07  6.529164e+02  1.289834e-04  1.925200e+04  3.060400e+04  2.356900e+04  2.113900e+04  8.137000e+04  4.017100e+04  1.844000e+03  5.243700e+04  1.875800e+04  4.181100e+04  5.665800e+04  2.307000e+04  4.137847e-01  1.599404e+00  1.211451e+00  1.074880e+00];

% l range
for i = 0.64646220:(1-0.64646220)/10:1
    x(4) = 1.415826e+00 * i;

realworlddata = [0.749644772755327,0.0686578815645776,0.00748711383812277];
load('coefficient_dragq.mat', 'coefficient_dragq');
load('coefficient_sideforceq.mat', 'coefficient_sideforceq');

% Random seed
seedX1 = x(11);
seedY1 = x(12);
seedZ1 = x(13);
seedX2 = x(14);
seedY2 = x(15);
seedZ2 = x(16);
seedX3 = x(17);
seedY3 = x(18);
seedZ3 = x(19);
seedX4 = x(20);
seedY4 = x(21);
seedZ4 = x(22);

if istable(x)
    %Noise params
    nV = x.nV;
    nH = x.nH;
    nS = x.nS;
    
    %Flow params
    V0 = x.V0;
    normalScaling = x.normalScaling;
    hd = x.hd;
    theta =  x.theta;

    %Contact params
    k = x.k;
    d = x.d;
    tw = x.tw;
    
else
    %Noise params
    nV = x(1);
    nH = x(2);
    nS = x(3);
    
    %Flow params
    V0 = x(4);
    normalScaling = x(5);
    hd = x(6);
    theta = x(7);

    %Contact modelling
    k = x(8);
    d = x(9);
    tw = x(10);

end


%Known params
rn =  125/2000; %Radius of nozzle in m
Cd = 0.185;
rb = 80/1000;
rb1 = 80/1000;
rb2 = 80/1000;
rb3 = 80/1000;
rb4 = 80/1000;
mb1 = 3/1000; %Balloon mass in kg
mb2 = 3/1000; %Balloon mass in kg
mb3 = 3/1000; %Balloon mass in kg
mb4 = 3/1000; %Balloon mass in kg

% interaction
simOut = sim("simulink_4_balloons",'FastRestart','off','SrcWorkspace'...
    ,'current');

% % no interaction
% simOut = sim("simulink_4_balloons_nointeraction",'FastRestart','off','SrcWorkspace'...
%     ,'current');

balloon1 = simOut.yout{1}.Values;
balloon2 = simOut.yout{2}.Values;
balloon3 = simOut.yout{3}.Values;
balloon4 = simOut.yout{4}.Values;
X1 = balloon1.x.data;
Y1 = balloon1.y.data;
Z1 = balloon1.z.data;
X2 = balloon2.x.data;
Y2 = balloon2.y.data;
Z2 = balloon2.z.data;
X3 = balloon3.x.data;
Y3 = balloon3.y.data;
Z3 = balloon3.z.data;
X4 = balloon4.x.data;
Y4 = balloon4.y.data;
Z4 = balloon4.z.data;

%%Position
meanZ = realworlddata(1);
varZ = realworlddata(2);
varXY = realworlddata(3);

meanZError = abs(((mean(Z1) + mean(Z2) + mean(Z3) + mean(Z4))/4 - meanZ)/meanZ);
varZError = abs(((var(Z1) + var(Z2) + var(Z3) + var(Z4))/4 - varZ)/varZ);
varXYError = abs(((var(X1) + var(Y1) + var(X2) + var(Y2) + ...
    var(X3) + var(Y3) + var(X4) + var(Y4))/8 - varXY)/varXY);
e = (meanZError + varZError + varXYError)/3;

filename = ['data_4_balloons_l`_' num2str(floor(i*100)) '.mat' ];
save(filename);
end
toc;
end

