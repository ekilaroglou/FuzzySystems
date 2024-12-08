function [D_trn,D_val,D_chk] = GetSameFrequencySamples(data,classes,f_max_difference)
%GETSAMEFREQUENCYSAMPLES Summary of this function goes here
%   Detailed explanation goes here
Number_of_classes = length(classes);
%f_max_difference = 0.02;
preproc=1;
D_trn_f = zeros(1,Number_of_classes);
D_val_f = zeros(1,Number_of_classes);
D_chk_f = zeros(1,Number_of_classes);

while(1)

    [D_trn,D_val,D_chk]=split_scale(data,preproc);

    brk = 0;
    for i=1:Number_of_classes
        D_trn_f(i) = sum(D_trn(:,end) == classes(i)) / size(D_trn,1);
        D_val_f(i) = sum(D_val(:,end) == classes(i)) / size(D_val,1);
        D_chk_f(i) = sum(D_chk(:,end) == classes(i)) / size(D_chk,1);
        if (abs(D_trn_f(i)-D_val_f(i)) > f_max_difference)
            brk = 1;
        end
        if (abs(D_trn_f(i)-D_chk_f(i)) > f_max_difference)
            brk = 1;
        end
        if (abs(D_val_f(i)-D_chk_f(i)) > f_max_difference)
            brk = 1;
        end
        if (brk == 1)
            break;
        end
    end
    if (brk == 1)
        continue;
    end
    break;
end
end

