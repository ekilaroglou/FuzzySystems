%read fis
fis = readfis('flc.fis');

%plot fis
%gensurf(fis)

%time vector
t = 0:0.01:30;
%initial value
omega = [150*ones(1,1000) 100*ones(1,1000) 150*ones(1,1001)];
%case_1 input
case_1 = timeseries(omega,t);

%time vector
t = 0:0.01:30;
%initial value
omega = [0.15*(0:999), 150*ones(1, 1000), 0.15*(1000:-1:0)];
%case_2 input
case_2 = timeseries(omega,t);

%time vector
t = 0:0.01:30;
%initial value
TL_vector = [zeros(1, 1000) ones(1, 1000) zeros(1,1001)];
%case_3 input
TL = timeseries(TL_vector,t);