function plotMFs(fis,unique_name,save,sub_plot,rename)
% MEMBERSHIP_FUNCTIONS - Creates the diagrams of the desired
% membership functions
    % INPUT
    %
    % fis           A fis. The function plots the membership
    %               functions of the fis inputs
    % unique_name   A unique name to add to the name of 
    %               each file (if saved)
    % save          Give value 1 to save the plots,
    %               otherwise the show up on screen
    % sub_plot      Give value 1 to make a subplot of all
    %               inputs. Otherwise each input will have
    %               its own plot.
    % rename        Give value 1 to rename inputs as x1,x2...
    %               And membership functions as m1,m2...
    %               for less space in inputs with a lot of mf
    % 
    % OUTPUT
    
    % if save then don't show figure
    if (save == 1)
        visible = 'off';
    else
        visible = 'on';
    end
    
    if (rename == 1)
        % Change input names and mf names
        for i = 1:length(fis.input)
            fis.input(i).name = ['x' num2str(i)];
            for j= 1:length(fis.input(i).mf)
                fis.input(i).mf(j).name = ['m' num2str(j)];
            end
        end
    end
    
    if (sub_plot == 1)
        % create figure with the watned visibility and position
        fig = figure('Position', [0 0 700 900],'visible',visible);
        
        % Get the number of fis inputs
        len = length(fis.input);
        for i=1:len
            % create the i subplot 
            % with len rows and 1 column
            P = subplot(len,1,i);
            plotmf(fis,'input',i);
            % make the subplot's ylabel invisible
            % so we can have only 1 ylabel in the figure
            set( get(P,'YLabel'), 'String', '' );            
        end
        % set Y label for all sublots (the figure's Ylabel)
        han=axes(fig,'visible','off'); 
        han.YLabel.Visible='on';
        ylabel(han,'Degree of membership');

        % save as png with the wanted name and close figure
        if (save == 1)
            saveas(fig, strcat('membership_functions_',unique_name),'png');
            close(fig);
        end
         
    else
        
        for i=1:length(fis.input)
            % create figure with the watned visibility and position
            fig = figure('Position', [0 0 700 900],'visible',visible);
            plotmf(fis,'input',i);
            
            % save and close figure
            if (save == 1)
                saveas(fig, strcat('membership_function_',...
                    unique_name,'_input',num2str(i)),'png');
                close(fig);
            end
        end  
    end
    
end

