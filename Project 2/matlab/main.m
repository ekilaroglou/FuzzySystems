% clear
clear
clc

% read fis
fis = readfis('fisdwdmdth.fis');
% θεωρούμε Δt = 1 sec
dt = 1;
% ταχύτητα
u = 0.05;
% αρχική θέση
x=4;
y=0.4;
% τελική θέση
destination = [10 3.2];

% track x,y
track_x = x;
track_y = y;

% αρική γωνία
theta_init = [0 -45 -90];
INIT = 3;

theta = theta_init(INIT);

% don't let while loop go forever
i = 1;

% max while circles
max_circles = 2000;


while (1)
    % calculate distance
    [dV,dH] = distance(x,y);
    % if out of bounds then break
    if ((dV < 0 || dH < 0))
        break;
    end
    
    % normalization
    dV = dV/4;
    dH = dH/10;
    
    % calculate new theta
    dTheta = evalfis([dV dH theta], fis);
    theta = CalculateTheta(theta,dTheta);
    % calculate new position
    x = x + u*cosd(theta)*dt;
    y = y + u*sind(theta)*dt;
    
    % track xy
    track_x(i+1) = x;
    track_y(i+1) = y;
    % increment
    i=i+1;
    if (i > max_circles)
        break;
    end
    
end

% figure
plot_obstacle()
stamp = ['time: ' num2str(floor((i-1)/60)) ' min ' num2str(mod(i-1, 60)) ' sec / θ = ', num2str(theta_init(INIT)), '°'];
plot(track_x, track_y); hold on;
plot(x, y, 'X', 'LineWidth', 1.8); hold on;
plot(destination(1), destination(2), '+', 'LineWidth', 1.8); hold on;
plot(track_x(1), track_y(1), 'O', 'LineWidth', 1.8)
title(stamp)
xlabel('x-axis')
ylabel('y-axis')
axis([0 inf 0 5])