function [dV,dH] = distance(x,y)
%DISTANCE Summary of this function goes here
%   Detailed explanation goes here

% calculate dH
if (y < 1)
    dH = 5-x;
elseif (y < 2)
    dH = 6-x;
elseif (y < 3)
    dH = 7-x;
else
    dH = 10;
end
    

% calculate dV
if (x < 5)
    dV = y;
elseif (x < 6)
    dV = y-1;
elseif (x < 7)
    dV = y-2;
else 
    dV = y-3;
end

% if out of bound then return negative
if (x < 0 ||x > 10 || y < 0 || y > 4)
    dV = -1;
    dH = -1;
end


end

