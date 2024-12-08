function Plot_RMSE_surf(RMSE_array,NF,randii,NR,ANR,save)
% 3D surf plot - Plots 4 different figures
% i) RMSE based on randii and NF
% ii) RMSE based on NF and randii. Here the only
% thing that changes is the axis of NF and randii
% for maybe a better view
% iii) RMSE based on NF and NR
% iv) RMSE based on NF and ANR
    % INPUT
    %
    % RMSE_array    The RMSE array based on Number of Features (rows)
    %               and randii (later we get NR or ANR based on randii)
    % NF   	        An array specifying the Number of Features (NF)
    % NR   	        An array specifying the Number of Rules (NR)
    % ANR   	    An array specifying the Average Number of Rules (ANR)
    % randii   	    An array specifying the randii values
    % save          Give value 1 to save the plots,
    %               otherwise the show up on screen
    % 
    % OUTPUT
if (save == 1)
    visible = 'off';
else
    visible = 'on';
end
fig = figure('Position', [0 0 900 900],'visible',visible);
[Xm,Ym] = ndgrid(NF,randii);
surf(Xm,Ym,RMSE_array);
colormap(cool);
colorbar;
title('RMSE based on randii and number of features')
xlabel('Number of Features')
ylabel('randii')
zlabel('RMSE')
if (save == 1)
    saveas(fig, 'RMSE_1_surf','png');
    close(fig);
end

fig = figure('Position', [0 0 900 900],'visible',visible);
surf(Ym,Xm,RMSE_array);
% surf(randii,NF,RMSE_array);
colormap(cool);
colorbar;
title('RMSE based on randii and number of features')
xlabel('randii')
ylabel('Number of Features')
zlabel('RMSE')
if (save == 1)
    saveas(fig, 'RMSE_2_surf','png');
    close(fig);
end

fig = figure('Position', [0 0 900 900],'visible',visible);
surf(NR,NF,RMSE_array);
colormap(cool);
colorbar;
title('RMSE based on number of rules and number of features')
xlabel('Number of Rules')
ylabel('Number of Features')
zlabel('RMSE')
if (save == 1)
    saveas(fig, 'RMSE_3_surf','png');
    close(fig);
end

fig = figure('Position', [0 0 900 900],'visible',visible);
surf(ANR,NF,RMSE_array);
colormap(cool);
colorbar;
title('RMSE based of average number of rules and number of features')
xlabel('Average Number of Rules')
ylabel('Number of Features')
zlabel('RMSE')
if (save == 1)
    saveas(fig, 'RMSE_4_surf','png');
    close(fig);
end
end

