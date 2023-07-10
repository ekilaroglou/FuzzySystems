function Plot_RMSE_scatter3(RMSE_array,xValues,yValues,save)
% 3D scatter plot - RMSE based on xValues(Number of features)
%                   and yValues (Number of Rules)
    % INPUT
    %
    % RMSE_array    The RMSE array based on Number of Features (rows)
    %               and randii (later we get NR or ANR based on randii)
    % xValues   	The xValues to plot. In main we specify Number
    %               of Features (NF)
    % yValues       The yValues to plot. In main we specify the
    %               Average Number of Rules (ANR)
    % save          Give value 1 to save the plots,
    %               otherwise the show up on screen
    % 
    % OUTPUT
xVals = [];
yVals = [];
zVals = [];

for i=1:length(xValues)
    for j=1:size(yValues,2)
        xVals = [xVals; xValues(i)];
        yVals = [yVals; yValues(j)];
        zVals = [zVals; RMSE_array(i,j)];
    end
end

if (save == 1)
    visible = 'off';
else
    visible = 'on';
end
fig = figure('Position', [0 0 900 900],'visible',visible);
scatter3(xVals,yVals,zVals,50,zVals)
grid on
grid minor
colormap(jet);
colorbar;
xlabel('Features')
ylabel('Rules')
zlabel('RMSE')
if (save == 1)
    saveas(fig, 'RMSE_scatter3','png');
    close(fig);
end
end