clc
clear
close all

% load data
data = load('haberman.data');
% Get the classes of the data
classes = GetClasses(data);

% 1) Split data in training, validation, checking data
% without trying to achieve same frequency for each class samples
% in the 3 datasets
% The results aren't good:
% preproc=1;
% [D_trn,D_val,D_chk]=split_scale(data,preproc);

% 2) Get training, validation and checking data
% with almost same frequency of each class
% f_max_difference = 0.02;
% [D_trn,D_val,D_chk] = GetSameFrequencySamples(data,classes,f_max_difference);
% The results are better than previously but not best

% 3) Use cv partition for Stratification. That way we
% can achieve the best similarity in all 3 datasets
% i) Get a 5-fold partition to Stratify the 80% and 20% of the data
% Then use these 20% to fill the checking data
cv = cvpartition(data(:,end),'Kfold',5,'Stratify',true);
chk_idx = cv.test(1);
trn_val_idx = cv.training(1);
D_chk = data(chk_idx,:);
D_trn_val = data(trn_val_idx,:);
% ii) Use the remaining 80% data and do a 4-Fold cvpartition
% to get stratify data of 60% and 20%
% 60% will be the training data while 20% the validation data
cv2 = cvpartition(D_trn_val(:,end),'Kfold',4,'Stratify',true);
val_idx = cv2.test(1);
trn_idx = cv2.training(1);
D_trn = D_trn_val(trn_idx,:);
D_val = D_trn_val(val_idx,:);

% CONSTANTS
% Randii values
save=1;
randii = [0.2 0.8];
epoch_number = 200;
class_dependent = [0 1];
Perf = zeros(4,2);
PA_array = zeros(4,length(classes));
UA_array = zeros(4,length(classes));
Error_matrix_all = {0 0 0 0};

 k = 1;
 for i=1:2
     for j = 1:2
         [Error_matrix,OA,PA,UA,kappa,Fis_val]=TSK_Classification(D_trn,D_val,D_chk,randii(i),class_dependent(j),classes,epoch_number, save);
         Perf(k,:) = [OA,kappa];
         UA_array(k,:) = UA;
         PA_array(k,:) = PA;
         Error_matrix_all{k} = Error_matrix;
         k = k + 1;
     end
 end
 
% Get table of OA and K
varnames={'OA','k'};
rownames={'0.2-class-independent','0.8-class-independent','0.2-class-dependent','0.8-class-dependent'};
Perf=array2table(Perf,'VariableNames',varnames,'RowNames',rownames);
write(Perf,'errors');

