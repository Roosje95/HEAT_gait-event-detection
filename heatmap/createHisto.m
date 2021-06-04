% function to create a figure with the heatmap of mean and SD absolute error,
% histogramm of error repartition for markers
% Input:
% - data_strung = struct of the data
%   data_strung.(nameCode).Heatmap.(top/side)
%   data_strung.(nameCode).histo
function createHisto(fig,title,data_struct)
%% define colors for each marker
colors = [[0 0 0]; ...%black heel
          [0 0.45 0.74]; ...%dark blue tpr
          [0 0 1]; ...%blue sita
          [0.72 0.27 1]; ...%violet ank
          [0.64 0.08 0.18]; ...%dark red foncé pmt1
          [1 0.41 0.16]; ...%red pmt5
          [0.93 0.69 0.13]; ...%orange cun
          [1 1 0]; ...%yellow dmt1
          [0 1 0]; ...%pale green dmt5
          [0.47 0.67 0.19]; ...%green toe
          [0.43 0.55 0.28]]; %dark green hlx

%% figure
    annotation(fig,'textbox',[0.4 0.95 0.2 0.05],'String',title, ...
                'FontSize',15,'FontWeight','bold','HorizontalAlignment','center', ...
                'LineStyle','none')
    codes = fieldnames(data_struct);
    nbCodes = length(codes);
    
    for i = 1:nbCodes
        subplot(3,2,i)
        b_histo = bar(data_struct.(codes{i,1}).histo,'FaceColor','flat','EdgeColor','none');
        for k = 1:11
            b_histo(k).CData = [colors(k,:);colors(k,:);colors(k,:);colors(k,:);colors(k,:)];
        end
%         ylim([0 65]) % norm
        ylim([0 155]) % patients
        ylabel(codes{i,1})
        xticklabels({'<-40','[-40;-20[','[-20;20]',']20;40]','>40'})
    end
    subplot(3,2,6)
    image( imread('C:\Users\FreslierM\Desktop\output\mqColors.png') );
    axis off
end