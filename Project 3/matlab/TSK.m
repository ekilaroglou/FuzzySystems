function [MSE,RMSE,R2,NMSE,NDEI] = TSK(D_trn,D_val,D_chk,input_membership_functions,output_type,epoch_number, save)
% TSK - creates the wanted plots of a TSK model with
% grid partitioning and other parameters shown below
    %
    % INPUT
    %
    % D_trn             The training data that will be used to create
    %                  and evaluate the model. Data should
    %                  have size(data,2) - 1 inputs
    %                  and 1 output
    % D_val             The validation data that will be used to create
    %                  and evaluate the model. Data should
    %                  have size(data,2) - 1 inputs
    %                  and 1 output
    % D_chk             The checking data that will be used to create
    %                  and evaluate the model. Data should
    %                  have size(data,2) - 1 inputs
    %                  and 1 output
    % input_membership_functions
    %                  The number of membership fuctnions
    %                  of each input. Must be scalar
    % output_type      The type of membership fuctnions
    %                  of each input. Must be 'constant'
    %                  or 'linear'
    % epoch_number     The number of epoch that will be used
    %                  to train the model
    % save             Give value 1 to save the plots,
    %                  otherwise the show up on screen
    % 
    % OUTPUT           
    %
    % A number of model evaluation parameters
    % MSE,RMSE,R2,NMSE,NDEI

% check if INPUT 'output_type' value is allowed
% otherwise throw an error
if (~strcmp(output_type,'constant') && ~strcmp(output_type,'linear'))
    error('input_membership_function_type should be constant or linear')
end


% Initialize Sugeno FIS for ANFIS training
% using grid partition
%fis = genfis1(D_trn,input_membership_functions,'gbellmf',input_membership_function_type);
opt = genfisOptions('GridPartition');
opt.NumMembershipFunctions = input_membership_functions;
opt.InputMembershipFunctionType = 'gbellmf';
opt.OutputMembershipFunctionType = output_type;
fis = genfis(D_trn(:,1:end-1), D_trn(:,end),opt);

% Train fis
% [fis,trainingError,stepSize,chkFIS,chkError] = anfis(D_trn,options);
[~,Error_trn,~,Fis_val,Error_val]=anfis(D_trn,fis,[epoch_number 0 0.01 0.9 1.1],[],D_val);

% Evaluate fis
anfisInput = D_chk(:,1:end-1);
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

% PLOTS

% give plots a unique name based on the TSK inputs
unique_name = strcat(num2str(input_membership_functions),'_',...
            output_type);
% plot error
plotErrors(Error_trn,Error_val,unique_name,save);

% plot membership functions
sub_plot = 1;
rename = 0;
plotMFs(Fis_val,unique_name,save,sub_plot,rename);

% plot predictions
plotPrediction(yd,y,unique_name,save);
end

