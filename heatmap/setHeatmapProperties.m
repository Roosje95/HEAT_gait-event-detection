% function to set the properties of the heatmap
% Input:
% - handle = handle of the heatmap
% - properties
% Output:
% - handle = handle of the heatmap
function handle = setHeatmapProperties(handle,title,xlabel,ylabel,colormap, ...
         colorlimits,colorbarvisible,celllabelcolor,celllabelformat,gridvisible)
    handle.Title = title;
    handle.XLabel = xlabel;
    handle.YLabel = ylabel;
    handle.Colormap = colormap;
    handle.ColorLimits = colorlimits;
    handle.ColorbarVisible = colorbarvisible;
    handle.MissingDataColor = 'white';
    handle.MissingDataLabel = '';
    handle.CellLabelColor = celllabelcolor;
    % h1.CellLabelFormat = celllabelformat; % typically '%.1f'
    handle.GridVisible = gridvisible;
end