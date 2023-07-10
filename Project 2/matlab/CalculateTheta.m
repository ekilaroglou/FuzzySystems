function [thetaNew] = CalculateTheta(thetaOld,dTheta)

thetaNew = thetaOld+dTheta;
if (thetaNew > 180)
    thetaNew = thetaNew - 360;
elseif (thetaNew < -180)
    thetaNew = thetaNew + 360;
end

end

