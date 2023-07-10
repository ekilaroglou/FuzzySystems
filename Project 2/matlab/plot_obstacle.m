function plot_obstacle()
    obs1 = linspace(5,6);
    obs2 = linspace(6,7);
    obs3 = linspace(7,10);
    obs4 = linspace(0,1);
    obs5 = linspace(1,2);
    obs6 = linspace(2,3);
    bot = linspace(5,10);
    right = linspace(0,3);
    plot(obs1, obs1*0+1, 'black', 'LineWidth', 1.5);hold on;
    plot(obs2, obs2*0+2, 'black', 'LineWidth', 1.5);hold on;
    plot(obs3, obs3*0+3, 'black', 'LineWidth', 1.5);hold on;
    plot(obs4*0+5, obs4, 'black', 'LineWidth', 1.5);hold on;
    plot(obs5*0+6, obs5, 'black', 'LineWidth', 1.5);hold on;
    plot(obs6*0+7, obs6, 'black', 'LineWidth', 1.5);hold on;
    plot(bot, bot*0, 'black', 'LineWidth', 1.5);hold on;
    plot(right*0+10, right, 'black', 'LineWidth', 1.5);hold on;
end