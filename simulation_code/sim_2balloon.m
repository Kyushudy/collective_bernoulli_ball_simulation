function [e] = sim_2balloon(x, realworlddata, coefficient_dragq, coefficient_sideforceq)

if istable(x)
%     %inheritance from d
%     nV = 4.314138e-04;
%     nH = 1.079427e-04;
%     nS = 5.011179e-02;
% 
%     %inheritance from d
%     V0 = 1.321429e+00;
%     normalScaling = 4.268420e-01;
%     hd = 4.886718e-02;
%     theta = 7.476421e+00;

    %Noise params
    nV = x.nV;
    nH = x.nH;
    nS = x.nS;

    %Flow params
    V0 = x.V0;
    normalScaling = x.normalScaling;
    hd = x.hd;
    theta = x.theta;

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

% Random seed
seedX1 = randi(100000);
seedY1 = randi(100000);
seedZ1 = randi(100000);
seedX2 = randi(100000);
seedY2 = randi(100000);
seedZ2 = randi(100000);

try
%     % interaction
%     simOut = sim("simulink_2_balloons",'FastRestart','off','SrcWorkspace'...
%         ,'current');
    
    % no interaction
    simOut = sim("simulink_2_balloons_nointeraction",'FastRestart','off','SrcWorkspace'...
        ,'current');
    
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

catch
    meanZError = NaN;
    varZError = NaN;
    varXYError = NaN;
    e = NaN;
end

if istable(x)
    
    foutput = fopen('optimization_record.txt','a');
    fprintf(foutput,'%e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e',...
        nV,nH,nS,V0,normalScaling,hd,theta,k,d,tw,...
        seedX1,seedY1,seedZ1,seedX2,seedY2,seedZ2,...
        meanZError,varZError,varXYError,e);
    fprintf(foutput,'\r\n');
    fclose(foutput);
    
else
    
    foutput = fopen('optimization_record.txt','a');
    fprintf(foutput,'%e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e',...
        x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),...
        seedX1,seedY1,seedZ1,seedX2,seedY2,seedZ2,...
        meanZError,varZError,varXYError,e);
    fprintf(foutput,'\r\n');
    fclose(foutput);

end
end

