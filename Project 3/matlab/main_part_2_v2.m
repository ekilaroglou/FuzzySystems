% % That's same with main_part_2
% but we instead use GridSearch function for a more
% clear code


clear
clc
close all

% save = 1 for save
save = 1;

% read csv starting from second row (row index = 1)
% in other words ignore headers
data = csvread('train.csv',1,0);

% split data and normalize to unit hypercube
preproc=1;
[D_trn,D_val,D_chk]=split_scale(data,preproc);

% % CONSTANTS
% Number of Features
% NF = [3 7 11 15];
% NF = [3 5 8 11 19 28];
NF = [3 5 8 11];
% Cluster center's range of influence
randii = [0.15 0.3 0.45 0.6];
% The number of epoch that will be used to train the model
epoch_number = 200;

% Get best value based on grid search
% Plot grid search results
[NF_final,randii_final, columns] = GridSearch(D_trn,NF,randii,epoch_number,save);

% % CREATE MODEL
% Train the model based on the above values
D_trn = D_trn(:,columns);
D_val = D_val(:,columns);
D_chk = D_chk(:,columns);

% Generate fis
opt = genfisOptions('SubtractiveClustering',...
                     'ClusterInfluenceRange',randii_final);
fis = genfis(D_trn(:,1:end-1), D_trn(:,end),opt);
%fis = genfis2(D_trn(:,end-1), D_trn(:,end),randii_final);
% Train the model
[~,Error_trn,~,Fis_val,Error_val]=anfis(D_trn,fis,[epoch_number 0 0.01 0.9 1.1],[],D_val);

% % EVALUATE THE MODEL
% get inputs of D_chk (checking data)
anfisInput = D_chk(:,1:end-1);

% % EXPLAINING OF THE NEXT FEW LINES OF CODE
% our model Fis_val is accepts values
% based on the min and max values of
% D_val and D_trn. More specifically
% D_trn is normalized to [0,1] (check
% split_scale) based on min and max value
% of D_trn of each input. In other words
% for a specific input x = (x-xmin)/(xmax-xmin).
% D_chk and D_val are also normalized based
% on the same xmin and xmax which means that
% they can take values from [a b] where 'a' could
% be a little lower or higher than 0 and 'b' a bit
% lower or higher than 1. The meaning of 'bit' is that
% a is almost 0 and b is almost 1. And that's because
% data are randomly distributed in all 3 sets (D_trn,
% D_chk, D_val) which means that max value of a
% D_trn input will be almost the same as the max value
% of D_chk or D_val of the same input. Same goes with min.

% That's being said if for a specific input:
% D_trn -> [0 1], D_val -> [a b], D_chk -> [c d]
% then the FIS (Fis_val) accept values
% [min(a,0) max(b,1)]. But our input data from
% D_chk can take values lower or higher than that
% (depends on c and d) which is an not accepted
% input value and evalfis will throw a warning.
% To avoid that warning we limit D_chk values 
% to [min(a,0) max(b,1)].
% That's not a problem for our model output because
% if for example the model is trained to take a max
% value of 1.03 then a value a bit higher than this
% i.e. 1.05 should be considered like max -> 1.03
% That's being said, if we do this proccess for all
% the inputs of the fis (evalfis function) the model
% will work properly and we will have no warnings.

for i=1:size(anfisInput,2)-1
    max = Fis_val.input(i).range(2);
    min = Fis_val.input(i).range(1);
    for j=1:size(anfisInput,1)
        if (anfisInput(j,i) > max)
            anfisInput(j,i) = max;
        end
        if (anfisInput(j,i) < min)
            anfisInput(j,i) = min;
        end
    end
end

% Now we have the input data normalized to the
% accepted values of the Fis_val.

% Evaluate fis
y = evalfis(anfisInput,Fis_val);

% Model evaluation methods
% 1) MSE and RMSE
% get last column of D_chk which is the wanted output yd
yd = D_chk(:,end);
%MSE = sum((yd-y).^2) / length(y);
MSE = mse(yd,y);
RMSE = sqrt(MSE);
% 2) R^2
yd_mean = mean(yd);
SSres = sum((yd-y).^2);
SStot = sum((yd-yd_mean).^2);
R2 = 1-SSres/SStot;
% 3) NMSE and NDEI
NMSE = 1-R2;
NDEI = sqrt(NMSE);

% % PLOTS

% give plots a unique name based on the TSK inputs
unique_name = 'high_dimension_data';
% plot error
plotErrors(Error_trn,Error_val,unique_name,save);

% plot membership functions
sub_plot = 0;
plotMFs(Fis_val,unique_name,save,sub_plot);

% plot predictions
plotPrediction(yd,y,unique_name,save);


