function [Error_matrix,OA,PA,UA,kappa,Fis_val] = TSK_Classification(D_trn,D_val,D_chk,randii,class_dependent,classes,epoch_number, save)

% Initialize Sugeno FIS for ANFIS training
% based on randii and based of 
% class dependent or class independent case
fis = Generate_FIS(D_trn,randii,class_dependent,classes);

% Train fis
[~,Error_trn,~,Fis_val,Error_val]=anfis(D_trn,fis,epoch_number,[],D_val);

% Evaluate fis
anfisInput = D_chk(:,1:end-1);

% Explanation of the below
% in main_part_2 in Project 3
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

y = evalfis(anfisInput,Fis_val);
% round results to be either 1 either 2
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

% PLOTS

% give plots a unique name based on the TSK inputs
if (class_dependent == 1)
    unique_name = strcat(num2str(randii*10),'_',...
                'class_dependent');
else
    unique_name = strcat(num2str(randii*10),'_',...
                'class_independent');
end

% plot error
plotErrors(Error_trn,Error_val,unique_name,save);

% plot membership functions
sub_plot = 1;
rename = 1;
plotMFs(Fis_val,unique_name,save,sub_plot,rename);

% plot predictions
plotPrediction(yd,y,unique_name,save);


end

