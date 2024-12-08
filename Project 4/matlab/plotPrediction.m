function plotPrediction(yd,y,unique_name,save)
% PREDICTION - Creates the diagrams of the desired
% prediction errors.
    % INPUT
    %
    % yd               The dataset output
    % y                The evaluation vector
    % unique_name      A unique name to add to the name of 
    %                  each file (if saved)
    % save             Give value 1 to save the plots,
    %                  otherwise the show up on screen
    % 
    % OUTPUT
    
% if save then don't show figure
if (save == 1)
    visible = 'off';
else
    visible = 'on';
end
    
% create figure with the watned visibility and position
fig = figure('Position', [0 0 700 900],'visible',visible);
number_of_instances=size(yd,1);
plot(1:number_of_instances, yd, '*r', 1:number_of_instances, y, '.b')
title('Value Predictions')
legend('Real Value', 'Predicted Value')

if (save == 1)
    saveas(fig, strcat('prediction_',unique_name),'png');
    close(fig);
end
end

