% function to create a figure with the heatmap of absolute error
% Input:
% - data_struct = struct of the data
%   data_strung.(nameCode).Heatmap.(top/side)
%   data_strung.(nameCode).histo
% - view = 'top' or 'side'
function createFig_heatmap(fig,title,data_struct,view)
%% figure
    annotation(fig,'textbox',[0.4 0.95 0.2 0.05],'String',title, ...
                'FontSize',15,'FontWeight','bold','HorizontalAlignment','center', ...
                'LineStyle','none')
    codes = fieldnames(data_struct);
    nbCodes = length(codes);
    n=1;
    for i = 1:nbCodes
        if i == nbCodes
            colorbarvisible = 'on';
        else
            colorbarvisible = 'off';
        end
        switch view
            case 'top'
                subplot(1,nbCodes,i)
            case 'side'
                subplot(3,2,i)
        end
        h = heatmap(data_struct.(codes{i,1}).Heatmap.(view)(:,:,n));
%         h = setHeatmapProperties(h,codes{i,1},[],[],jet,[-11 12], ...
%                           colorbarvisible,'none','','off');
        h = setHeatmapProperties(h,codes{i,1},[],[],jet,[-60 60], ...
                          colorbarvisible,'none','','off');
    end
end