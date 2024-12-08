function MF_before_after(fis,Fis_val,save)
    % if save then don't show figure
    if (save == 1)
        visible = 'off';
    else
        visible = 'on';
    end
    % create figure with the watned visibility and position
    fig = figure('Position', [0 0 700 900],'visible',visible);

    P1 = subplot(3,2,1);
    plotmf(fis,'input',1);
    % make the subplot's ylabel invisible
    % so we can have only 1 ylabel in the figure
    set( get(P1,'YLabel'), 'String', '' );    
    set( get(P1,'XLabel'), 'String', 'in1 before' );  
    P2 = subplot(3,2,2);
    plotmf(Fis_val,'input',1);
    % make the subplot's ylabel invisible
    % so we can have only 1 ylabel in the figure
    set( get(P2,'YLabel'), 'String', '' );   
    set( get(P2,'XLabel'), 'String', 'in1 after' );  
    P3 = subplot(3,2,3);
    plotmf(fis,'input',2);
    % make the subplot's ylabel invisible
    % so we can have only 1 ylabel in the figure
    set( get(P3,'YLabel'), 'String', '' );   
    set( get(P3,'XLabel'), 'String', 'in2 before' );  
    P4 = subplot(3,2,4);
    plotmf(Fis_val,'input',2);
    % make the subplot's ylabel invisible
    % so we can have only 1 ylabel in the figure
    set( get(P4,'YLabel'), 'String', '' );   
    set( get(P4,'XLabel'), 'String', 'in2 after' );  
    P5 = subplot(3,2,5);
    plotmf(fis,'input',14);
    % make the subplot's ylabel invisible
    % so we can have only 1 ylabel in the figure
    set( get(P5,'YLabel'), 'String', '' );   
    set( get(P5,'XLabel'), 'String', 'in14 before' );  
    P6 = subplot(3,2,6);
    plotmf(Fis_val,'input',14);
    % make the subplot's ylabel invisible
    % so we can have only 1 ylabel in the figure
    set( get(P6,'YLabel'), 'String', '' );   
    set( get(P6,'XLabel'), 'String', 'in14 after' );  


    % set Y label for all sublots (the figure's Ylabel)
    han=axes(fig,'visible','off'); 
    han.YLabel.Visible='on';
    ylabel(han,'Degree of membership');
    % save and close figure
    if (save == 1)
    saveas(fig, 'MF_before_after','png');
    close(fig);
    end
end

