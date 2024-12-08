clear
clc
close all

% read csv starting from second row (row index = 1)
% in other words ignore headers
data = csvread('data.csv',1,1);

% split data and normalize to unit hypercube
preproc=1;
[D_trn,D_val,D_chk]=split_scale(data,preproc);

second_dimension_size = size(data,2);
idx=zeros(300,second_dimension_size-1);
weights=zeros(300,second_dimension_size-1);

for k=1:300
    [idx(k,:), weights(k,:)] = relieff(D_trn(:,1:end-1), D_trn(:, end), k);
     x=k
end

% plots
plots_K(idx(1:150,:), weights(1:150,:));