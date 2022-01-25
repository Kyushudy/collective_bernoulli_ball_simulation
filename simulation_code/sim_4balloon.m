function [e] = sim_4balloon(x, realworlddata, coefficient_dragq, coefficient_sideforceq)

if istable(x)

%     %inheritance from i*
%     nV = 1.873147e-03;
%     nH = 4.449649e-04;
%     nS = 5.948637e-02;
% 
    %inheritance from i*
    V0 = 2.153211e+00;
    normalScaling = 7.063997e-01;
    hd = 4.829856e-02;
    theta = 7.430003e+00; 

    %inheritance from i*
    k = 1.362010e+07;
    d = 1.831135e+02;
    tw = 1.271078e-04;
    
    %Noise params
    nV = x.nV;
    nH = x.nH;
    nS = x.nS;
    
%     %Flow params
%     V0 = x.V0;
%     normalScaling = x.normalScaling;
%     hd = x.hd;
%     theta =  x.theta;
% 
%     %Contact params
%     k = x.k;
%     d = x.d;
%     tw = x.tw;
    
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

% Random seed
seedX1 = randi(100000);
seedY1 = randi(100000);
seedZ1 = randi(100000);
seedX2 = randi(100000);
seedY2 = randi(100000);
seedZ2 = randi(100000);
seedX3 = randi(100000);
seedY3 = randi(100000);
seedZ3 = randi(100000);
seedX4 = randi(100000);
seedY4 = randi(100000);
seedZ4 = randi(100000);

try
    % interaction
    simOut = sim("simulink_4_balloons",'FastRestart','off','SrcWorkspace'...
        ,'current');
    
%     % no interaction
%     simOut = sim("simulink_4_balloons_nointeraction",'FastRestart','off','SrcWorkspace'...
%         ,'current');
    
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

catch
    meanZError = NaN;
    varZError = NaN;
    varXYError = NaN;
    e = NaN;
end

if istable(x)
    
    foutput = fopen('optimization_record.txt','a');
    fprintf(foutput,'%e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e',...
        nV,nH,nS,V0,normalScaling,hd,theta,k,d,tw,...
        seedX1,seedY1,seedZ1,seedX2,seedY2,seedZ2,...
        seedX3,seedY3,seedZ3,seedX4,seedY4,seedZ4,...
        meanZError,varZError,varXYError,e);
    fprintf(foutput,'\r\n');
    fclose(foutput);
    
else
    
    foutput = fopen('optimization_record.txt','a');
    fprintf(foutput,'%e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e',...
        x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),...
        seedX1,seedY1,seedZ1,seedX2,seedY2,seedZ2,...
        seedX3,seedY3,seedZ3,seedX4,seedY4,seedZ4,...
        meanZError,varZError,varXYError,e);
    fprintf(foutput,'\r\n');
    fclose(foutput);

end
end

