function [classes] = GetClasses(data)
%GETCLASSES Summary of this function goes here
%   Detailed explanation goes here
values(1) = 0;
j = 2;
for i=1:size(data,1)
    if (~any(values(:)==data(i,end)))
         values(j) = data(i,end);
         j = j+1;
    end
end

classes = values(2:end);
end

