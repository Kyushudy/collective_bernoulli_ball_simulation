function [e] = sim_1balloon_test(x, realworlddata)
tic;

% % a
% x = [0.000000e+00  0.000000e+00  0.000000e+00  4.967139e+00  7.621206e-01  4.058440e-04  7.290915e+00  8.749800e+04  1.518000e+04  1.626700e+04  9.564686e-02  5.625739e-01  1.000000e+00  5.527402e-01];

% a`
x = [0.000000e+00  0.000000e+00  0.000000e+00  1.321429e+00  4.268420e-01  4.886718e-02  7.476421e+00  5.706800e+04  4.100000e+04  5.992600e+04  1.843254e-03  9.943995e-01  1.000000e+00  1.843254e-03];

% a`- 8.542539e-01 0.64646220 
% a`-- 4.947703e-01 0.37442065

% % b
% x = [4.314138e-04  1.079427e-04  5.011179e-02  1.321429e+00  4.268420e-01  4.886718e-02  7.476421e+00  1.267800e+04  5.989600e+04  7.409100e+04  7.552885e-02  1.367107e-01  1.393909e-01  1.172102e-01];

% % c
% x = [4.463451e-03  2.446612e-04  9.712691e-02  1.159965e+00  9.961817e-01  2.618035e-02  5.258508e+00  2.025000e+04  3.238000e+04  7.292400e+04  2.464568e-01  3.296536e-01  4.235238e-01  3.332114e-01];

% % c`
% x = [5.086304e-03  1.377001e-03  5.322751e-02  1.219213e+00  9.962460e-01  2.445370e-02  3.350562e+00  3.670500e+04  7.353400e+04  9.235500e+04  8.088785e-02  2.272717e-02  3.396662e-01  1.477604e-01];

realworlddata = [0.959401491219557,0.0336482493432626,0.00220841736489035];

% Random seed
seedX1 = x(8);
seedY1 = x(9);
seedZ1 = x(10);

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
end


%Known params
rn =  125/2000; %Radius of nozzle in m
Cd = 0.185;
rb = 80/1000;
rb1 = 80/1000;
mb1 = 3/1000; %Balloon mass in kg


simOut = sim("simulink_1_balloons",'FastRestart','off','SrcWorkspace'...
    ,'current');

balloon1 = simOut.yout{1}.Values;
X1 = balloon1.x.data;
Y1 = balloon1.y.data;
Z1 = balloon1.z.data;

%%Position
meanZ = realworlddata(1);
varZ = realworlddata(2);
varXY = realworlddata(3);

meanZError = abs((mean(Z1) - meanZ)/meanZ);
varZError = abs((var(Z1) - varZ)/varZ);
varXYError = abs(((var(X1) + var(Y1))/2 ...
    - varXY)/varXY);
e = (meanZError + varZError + varXYError)/3;


toc;
end

