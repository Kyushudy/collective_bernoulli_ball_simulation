function [V] = flowSpeed(meanFlowVelocity,rFlow,x,y)

V =  meanFlowVelocity*normpdf(x,0,rFlow)*normpdf(y,0,rFlow);

end

