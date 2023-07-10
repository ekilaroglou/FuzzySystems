function [NF_final,randii_final,columns] = GridSearch(D_trn,NF,randii,epoch_number,save)
%GRIDSEARCH Summary of this function goes here
%   Detailed explanation goes here


% % TRAIN MODEL AND DO GRID SEARCH USING ONLY TRAINING DATA
% reason:
% https://stats.stackexchange.com/questions/453221/should-i-use-gridsearchcv-on-all-of-my-data-or-just-the-training-set

% % FIND THE INDECES OF THE BEST FEATURES BASED ON RELIEF

% Predictor ranks and weights usually depend on k.
% If you set k to 1, then the estimates can be unreliable
% for noisy data. If you set k to a value comparable with 
% the number of observations (rows) in X, relieff can fail 
% to find important predictors
% Source: 
% https://www.mathworks.com/help/stats/relieff.html


% if we wanted to find the best k (number/size/amount of
% nearest neighboors selected for each iteration)
% we could make a plot of the weights
% of the first most important predictors
% based on different k values.
% At one point we would see that the weights
% doesn't change anymore. That means that taking 
% into account another neighbour does not give a better
% modelling of the data.
% Source:
% https://stackoverflow.com/questions/35969044/how-to-choose-value-of-k-in-relieff-algorithm-in-matlab

% After trying to find the best k
% idk=zeros(200,81);
% weights=zeros(200,81);
% 
% for k=1:200
%     [idx(k,:), weights(k,:)] = relieff(data(:,1:81), data(:, 82), k);
%     x=k
% end
% for i=1:81
%     plot(w(:,i))
%     hold on
% end


% We get a good value for k
k = 80;
% find the indeces and the weights for that k
[idx, ~] = relieff(D_trn(:,1:81), D_trn(:, 82), k);

% % CONSTANTS
% Number of samples
N = size(D_trn,1);
% K_fold size
K_fold = 5;

% get the indices for KFold Cross Validation
indices = crossvalind('Kfold',N,K_fold);

% pre-allocate space for RMSE
RMSE_array = zeros(length(NF),length(randii));
% pre-allocate space for NR (number of rules)
NR = zeros(length(NF),length(randii));
% average NR
ANR = zeros(length(NF),length(randii));
% % GRID SEARCH
% For each Number of Features NF
% AND
% For each Cluster center's range randii
% i) Do cross validation
% ii) Find the average RMSE
% iii) Store it to RMSE(i,j)
for i=1:length(NF)
    for j=1:length(randii)
        % Number of features
        numbers_of_features = NF(i);
        % Cluster Influence Range
        r_a = randii(j);
        % Initiallize RMSE
        RMSE_cal = 0;
        ANR_cal = 0;
        
        % Get the wanted columns which is
        % 1) the input columns with index
        % based on the indeces (idx)
        % of the NF(i) most important features
        % 2) the output column with index 82
        columns = [idx(1:numbers_of_features) 82];
        
        % Do Cross Validation and calculate
        % The average RMSE
        % In our case K_fold = 5
        % So run the following 5 times
        for q=1:K_fold
            % Get the validation data based on indeces == q
            % of the cross validation
            D_trn_val = D_trn(indices == q, columns);
            D_trn_trn = D_trn(indices ~= q, columns);
            
            % Generate Fuzzy Inference System structure
            % from data using subtractive clustering
            opt = genfisOptions('SubtractiveClustering',...
                    'ClusterInfluenceRange',r_a);
            fis = genfis(D_trn_trn(:,1:end-1), D_trn_trn(:,end),opt);
                
            % Train the model and get the Validation Error
            [~,~,~,Fis_val,Error_val]=anfis(D_trn_trn,fis,[epoch_number 0 0.01 0.9 1.1],[],D_trn_val);
            
            % Get the minimum Error_val which is error
            % based on which the returned Fis_val of the
            % anfis is tuned
            % Then add it to RMSE_cal to find the
            % mean value of all 5 loops
            RMSE_cal = RMSE_cal + min(Error_val);
            ANR_cal = ANR_cal + size(showrule(Fis_val), 1);
        end
        
        % Number of rules for these parameters
        NR(i,j) = size(showrule(Fis_val), 1);
        ANR_cal = ANR_cal / K_fold;
        ANR(i,j) = ANR_cal;   
        % Mean RMSE
        RMSE_cal = RMSE_cal / K_fold;
        % Save RMSE
        RMSE_array(i,j) = RMSE_cal;   
    end
end

% PLOTS RMSE BASED ON randii, NF and NR
% Plot 5 figures
Plot_RMSE_surf(RMSE_array,NF,randii,NR,ANR,save);
Plot_RMSE_scatter3(RMSE_array,NF,ANR,save);

% Find the minimum RMSE
RMSE_min = min(min(RMSE_array));
% Find the indeces i,j of the minimum RMSE
[i, j] = find(RMSE_array == RMSE_min);
% Get the Number of Features and
% Cluster center's range of influence
% that's best for our model based on the grid search
NF_final = NF(i);
randii_final = randii(j);
% Get the wanted columns
columns = [idx(1:NF_final) 82];
end

