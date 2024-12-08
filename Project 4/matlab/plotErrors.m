function plotErrors(Error_trn,Error_val,unique_name,save)
% ERRORS - Prints the desired errors based on number of iterations.
    %
    % INPUT
    %
    % Error_trn        A training_error array based on 
    %                  number of iterations
    % Error_val        A validation_error array based on
    %                  number of iterations
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
plot([Error_trn.^2 Error_val.^2 ],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('ANFIS Hybrid Training - Validation');

if (save == 1)
    saveas(fig, strcat('error_',unique_name),'png');
    close(fig);
end
end

