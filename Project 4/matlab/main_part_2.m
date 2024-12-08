clear
clc
close all

% save = 1 for save
save = 1;
class_dependent = 1;

% read csv starting from second row (row index = 1)
% in other words ignore headers
data = csvread('data.csv',1,1);

% Get the classes of the data
classes = sort(GetClasses(data));
% Use cv partition for Stratification. That way we
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
% idk=zeros(200,178);
% weights=zeros(200,178);
% 
% for k=1:200
%     [idx(k,:), weights(k,:)] = relieff(D_trn(:,1:178), data(:, 179), k);
%     x=k
% end
% for i=1:178
%     plot(weights(:,i))
%     hold on
% end


% We get a good value for k
k = 120;
% find the indeces and the weights for that k
[idx, weights] = relieff(D_trn(:,1:end-1), D_trn(:, end), k);

% % CONSTANTS
% Number of Features
NF = [4 6 10 14];
% Cluster center's range of influence
randii = [0.3 0.45 0.6 0.75];
%The number of epoch that will be used to train the model
epoch_number = 200;
% K_fold size
K_fold = 5;

% Do cross validation
cv = cvpartition(D_trn(:,end),'Kfold',K_fold,'Stratify',true);

% pre-allocate space for RMSE
RMSE_array = zeros(length(NF),length(randii));
% pre-allocate space for NR (number of rules)
NR = zeros(length(NF),length(randii));
% average NR
ANR = zeros(length(NF),length(randii));
asdf=0;
% % GRID SEARCH
% For each Number of Features NF
% AND
% For each Cluster center's range randii
% i) Do cross validation
% ii) Find the average RMSE
% iii) Store it to RMSE(i,j)
for i=1:length(NF)
    for j=1:length(randii)
        %count
        asdf = asdf + 1
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
        columns = [idx(1:numbers_of_features) size(data,2)];
        
        % Do Cross Validation and calculate
        % The average RMSE
        % In our case K_fold = 5
        % So run the following 5 times
        for q=1:K_fold
            % Get the validation data based on indeces of cv.test(q)
            % and the training data based on indeces of cv.training(q)
            trn_trn_idx = cv.training(q);
            trn_val_idx = cv.test(q);
            D_trn_trn = D_trn(trn_trn_idx,columns);
            D_trn_val = D_trn(trn_val_idx,columns);

            % Generate Fuzzy Inference System structure
            % from data using subtractive clustering
            fis = Generate_FIS(D_trn_trn,r_a,class_dependent,classes);
                
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

% % CREATE MODEL
% Train the model based on the above values
% Get the wanted columns
columns = [idx(1:NF_final) size(data,2)];
D_trn = D_trn(:,columns);
D_val = D_val(:,columns);
D_chk = D_chk(:,columns);

% Generate fis
fis = Generate_FIS(D_trn,randii_final,class_dependent,classes);
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

for i=1:size(anfisInput,2)
    maxInput = Fis_val.input(i).range(2);
    minInput = Fis_val.input(i).range(1);
    for j=1:size(anfisInput,1)
        if (anfisInput(j,i) > maxInput)
            anfisInput(j,i) = maxInput;
        end
        if (anfisInput(j,i) < minInput)
            anfisInput(j,i) = minInput;
        end
    end
end

% Now we have the input data normalized to the
% accepted values of the Fis_val.

% Evaluate fis
y = evalfis(anfisInput,Fis_val);
y = round(y);
for i=1:length(y)
    if (y(i) < min(classes))
        y(i) = min(classes);
    end
    if (y(i) > max(classes))
        y(i) = max(classes);
    end
end

% Model evaluation methods
% get last column of D_chk which is the wanted output yd
yd = D_chk(:,end);
Number_of_classes = length(classes);

Error_matrix = zeros(Number_of_classes, Number_of_classes);

for i=1:Number_of_classes
    for j=1:Number_of_classes
        % get logical array that y in class(i)
        logical_y = (y == classes(i));
        logical_yd = (yd == classes(j));
        Error_matrix(i,j) = sum((logical_y & logical_yd));
    end
end

N = length(yd);

OA = sum(diag(Error_matrix)) / N;

xir = sum(Error_matrix,2);
xjc = sum(Error_matrix,1);

PA = diag(Error_matrix)./xjc';
UA = diag(Error_matrix)./xir;

kappa = (N*sum(diag(Error_matrix)) - xjc*xir)/(N^2-xjc*xir);

% % PLOTS

% give plots a unique name based on the TSK inputs
unique_name = 'high_dimension_data';
% plot error
plotErrors(Error_trn,Error_val,unique_name,save);

% plot predictions
plotPrediction(yd,y,unique_name,save);

% plot membership functions
sub_plot = 0;
rename = 0;
plotMFs(Fis_val,unique_name,save,sub_plot,rename);

% plot membership functions before training
unique_name = 'high_dimension_data_before';
plotMFs(fis,unique_name,save,sub_plot,rename);

% plot a subplot of inputs before and after (it's hard coded for the
% specific dataset
MF_before_after(fis,Fis_val,save);


