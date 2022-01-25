function [e] = sim_2balloon_test(x, realworlddata, coefficient_dragq, coefficient_sideforceq)
tic;

% % d
% x = [4.314138e-04  1.079427e-04  5.011179e-02  1.321429e+00  4.268420e-01  4.886718e-02  7.476421e+00  5.902597e+06  8.280372e+02  5.026856e-05  3.332700e+04  4.064000e+03  9.692900e+04  4.298100e+04  8.081200e+04  2.965900e+04  1.705268e-01  2.305534e-02  3.539460e-01  1.825094e-01];

% % e
% x = [3.610048e-04  5.762519e-05  5.315205e-02  1.321429e+00  4.268420e-01  4.886718e-02  7.476421e+00  7.093398e+06  8.465990e+02  8.355399e-05  9.996400e+04  7.563100e+04  9.593300e+04  6.035400e+04  8.638300e+04  4.689200e+04  1.932362e-01  1.314940e-01  6.856506e-01  3.367936e-01];

% % f
% x = [4.145203e-03  2.019477e-03  6.101864e-02  1.992609e+00  9.878700e-01  4.621446e-02  6.546374e+00  8.024223e+06  1.220092e+02  1.345147e-04  9.913500e+04  1.200200e+04  2.191200e+04  3.440400e+04  6.250000e+04  6.421700e+04  2.013436e-01  4.311513e-01  9.103786e-02  2.411776e-01];

% % g
% x = [4.314138e-04  1.079427e-04  5.011179e-02  1.321429e+00  4.268420e-01  4.886718e-02  7.476421e+00  1.342843e+07  7.960889e+02  1.366881e-04  3.332700e+04  4.064000e+03  9.692900e+04  4.298100e+04  8.081200e+04  2.965900e+04  1.682243e-01  2.846717e-02  3.954332e-01  1.973749e-01];

% % h
% x = [3.334771e-04  8.907545e-05  5.631818e-02  1.321429e+00  4.268420e-01  4.886718e-02  7.476421e+00  1.454252e+07  3.262231e+02  1.312874e-04  9.180000e+02  7.791200e+04  5.893000e+04  6.775900e+04  3.032300e+04  4.129700e+04  1.972067e-01  1.851662e+00  1.271480e+00  1.106783e+00];

% i
x = [5.553008e-03  3.356235e-03  5.855038e-02  1.108140e+00  9.984463e-01  4.244220e-02  3.229509e+00  1.042516e+07  9.544455e+02  1.421273e-04  5.686200e+04  2.789700e+04  1.717200e+04  9.490300e+04  8.327900e+04  2.785500e+04  1.610992e-01  1.377514e-02  2.747839e-01  1.498861e-01];

% % i`
% x = [1.873147e-03  4.449649e-04  5.948637e-02  2.153211e+00  7.063997e-01  4.829856e-02  7.430003e+00  1.362010e+07  1.831135e+02  1.271078e-04  6.859300e+04  9.293000e+03  2.826100e+04  3.347800e+04  8.651500e+04  1.537200e+04  6.540446e-03  1.175057e-02  1.583676e-01  5.888621e-02];

realworlddata = [0.872372614910137,0.0302418952594271,0.00269477639729602];
load('coefficient_dragq.mat', 'coefficient_dragq');
load('coefficient_sideforceq.mat', 'coefficient_sideforceq');

% Random seed
seedX1 = x(11);
seedY1 = x(12);
seedZ1 = x(13);
seedX2 = x(14);
seedY2 = x(15);
seedZ2 = x(16);

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
mb1 = 3/1000; %Balloon mass in kg
mb2 = 3/1000; %Balloon mass in kg

% interaction
simOut = sim("simulink_2_balloons",'FastRestart','off','SrcWorkspace'...
    ,'current');

% % no interaction
% simOut = sim("simulink_2_balloons_nointeraction",'FastRestart','off','SrcWorkspace'...
%     ,'current');

balloon1 = simOut.yout{1}.Values;
balloon2 = simOut.yout{2}.Values;
X1 = balloon1.x.data;
Y1 = balloon1.y.data;
Z1 = balloon1.z.data;
X2 = balloon2.x.data;
Y2 = balloon2.y.data;
Z2 = balloon2.z.data;

%%Position
meanZ = realworlddata(1);
varZ = realworlddata(2);
varXY = realworlddata(3);

meanZError = abs(((mean(Z1) + mean(Z2))/2 - meanZ)/meanZ);
varZError = abs(((var(Z1) + var(Z2))/2 - varZ)/varZ);
varXYError = abs(((var(X1) + var(Y1) + var(X2) + var(Y2))/4 ...
    - varXY)/varXY);
e = (meanZError + varZError + varXYError)/3;


toc;
end

