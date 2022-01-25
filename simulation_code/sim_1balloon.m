function [e] = sim_1balloon(x, realworlddata)

if istable(x)
    %inheritance
    nV = 0;
    nH = 0;
    nS = 0;
    
    %inheritance
    normalScaling = 4.268420e-01;
    hd = 4.886718e-02;
    theta = 7.476421e+00;

%     %inheritance
%     V0 = 1.321429e+00;
%     normalScaling = 4.268420e-01;
%     hd = 4.886718e-02;
%     theta = 7.476421e+00;

%     %Noise params
%     nV = x.nV;
%     nH = x.nH;
%     nS = x.nS;
    
    %Flow params
    V0 = x.V0;
%     normalScaling = x.normalScaling;
%     hd = x.hd;
%     theta =  x.theta;
    
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

% Random seed
seedX1 = randi(100000);
seedY1 = randi(100000);
seedZ1 = randi(100000);

try
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
    
    % a*
    e = meanZError;

catch
    meanZError = NaN;
    varZError = NaN;
    varXYError = NaN;
    e = NaN;
end

if istable(x)
    
    foutput = fopen('optimization_record.txt','a');
    fprintf(foutput,'%e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e',...
        nV,nH,nS,V0,normalScaling,hd,theta,...
        seedX1,seedY1,seedZ1,...
        meanZError,varZError,varXYError,e);
    fprintf(foutput,'\r\n');
    fclose(foutput);
    
else
    
    foutput = fopen('optimization_record.txt','a');
    fprintf(foutput,'%e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e  %e',...
        x(1),x(2),x(3),x(4),x(5),x(6),x(7),...
        seedX1,seedY1,seedZ1,...
        meanZError,varZError,varXYError,e);
    fprintf(foutput,'\r\n');
    fclose(foutput);

end
end

