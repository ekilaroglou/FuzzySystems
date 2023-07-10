clc
clear
close all
%  % Import Data
data = load('airfoil_self_noise.dat');

% split data and normalize to unit hypercube
preproc=1;
[D_trn,D_val,D_chk]=split_scale(data,preproc);

Perf = zeros(4,5);
% % 2 membership functions, constant output
[MSE,RMSE,R2,NMSE,NDEI] = TSK(D_trn,D_val,D_chk,2,'constant',200,1);
Perf(1,:) = [MSE,RMSE,R2,NMSE,NDEI];
% % 3 membership functions, constant output
[MSE,RMSE,R2,NMSE,NDEI] = TSK(D_trn,D_val,D_chk,3,'constant',200,1);
Perf(2,:) = [MSE,RMSE,R2,NMSE,NDEI];
% % 2 membership functions, linear output
[MSE,RMSE,R2,NMSE,NDEI] = TSK(D_trn,D_val,D_chk,2,'linear',200,1);
Perf(3,:) = [MSE,RMSE,R2,NMSE,NDEI];
% % 3 membership functions, linear output
[MSE,RMSE,R2,NMSE,NDEI] = TSK(D_trn,D_val,D_chk,3,'linear',200,1);
Perf(4,:) = [MSE,RMSE,R2,NMSE,NDEI];

% save Perf array as table
varnames={'MSE','RMSE','R2','NMSE','NDEI'};
rownames={'2-constant','3-constant','2-linear','3-linear'};
Perf=array2table(Perf,'VariableNames',varnames,'RowNames',rownames);
write(Perf,'errors');