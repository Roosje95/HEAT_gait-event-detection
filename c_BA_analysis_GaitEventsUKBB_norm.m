    %% BA_analysis_GaitEventsUKBB for Norm

    % https://www.mathworks.com/matlabcentral/fileexchange/45049-bland-altman-and-correlation-plot
    % Used functions from Ran Klein 23Aug 2019

    % Output: Bland Altman plots
    % Used: Limits of agreement, Bias, p-value ks-test(normality test)

%     %% set-up
%     addpath('P:\Projects\NCM_CP\read_only\Codes\Codes_Basics\BlandAltman');
%     addpath('P:\Projects\NCM_CP\project_only\NCM_CP_GaitEventDetection\Project_Marie');

%     load('output\results_patients.mat')
    exportFolder  = 'C:\Users\FreslierM\Desktop\output';
    load([exportFolder '\results_norm.mat'])

    %% Prep input data for calculations
    Error_values=struct; 
    % overall values
    Error_values.IC.overall.Ghoussayni=results_norm.FS_error_Ghoussayni;
    Error_values.IC.overall.Zeni=results_norm.FS_error_Zeni;
    Error_values.IC.overall.Desailly=results_norm.FS_error_Desailly;
    Error_values.IC.overall.Hsue=results_norm.FS_error_Hsue;
    Error_values.IC.overall.Hreljac=results_norm.FS_error_Hreljac;
    Error_values.soleBeforeIC.overall=results_norm.soleAngle_beforeFS;

    Error_values.TO.overall.Ghoussayni=results_norm.FO_error_Ghoussayni;
    Error_values.TO.overall.Zeni=results_norm.FO_error_Zeni;
    Error_values.TO.overall.Desailly=results_norm.FO_error_Desailly;
    Error_values.TO.overall.Hsue=results_norm.FO_error_Hsue;
    Error_values.TO.overall.Hreljac=results_norm.FO_error_Hreljac;
    Error_values.varusBeforeTO.overall=results_norm.varusAngle_beforeFO;

    % groups based on sole angle before IC
    g1=1; g2=1;g3=1;g4=1;
    for i=1:length(results_norm.soleAngle_beforeFS_grp)
        if results_norm.soleAngle_beforeFS_grp(i)==1
            Error_values.IC.g1.Ghoussayni(g1,:)=results_norm.FS_error_Ghoussayni(i,:);
            Error_values.IC.g1.Zeni(g1,:)=results_norm.FS_error_Zeni(i,:);
            Error_values.IC.g1.Desailly(g1,:)=results_norm.FS_error_Desailly(i,:);
            Error_values.IC.g1.Hsue(g1,:)=results_norm.FS_error_Hsue(i,:);
            Error_values.IC.g1.Hreljac(g1,:)=results_norm.FS_error_Hreljac(i,:);
            Error_values.soleBeforeIC.g1(g1,:)=results_norm.soleAngle_beforeFS(i,:);
            g1=g1+1;
        elseif results_norm.soleAngle_beforeFS_grp(i)==2
            Error_values.IC.g2.Ghoussayni(g2,:)=results_norm.FS_error_Ghoussayni(i,:);
            Error_values.IC.g2.Zeni(g2,:)=results_norm.FS_error_Zeni(i,:);
            Error_values.IC.g2.Desailly(g2,:)=results_norm.FS_error_Desailly(i,:);
            Error_values.IC.g2.Hsue(g2,:)=results_norm.FS_error_Hsue(i,:);
            Error_values.IC.g2.Hreljac(g2,:)=results_norm.FS_error_Hreljac(i,:);
            Error_values.soleBeforeIC.g2(g2,:)=results_norm.soleAngle_beforeFS(i,:);
            g2=g2+1;
         elseif results_norm.soleAngle_beforeFS_grp(i)==3
            Error_values.IC.g3.Ghoussayni(g3,:)=results_norm.FS_error_Ghoussayni(i,:);
            Error_values.IC.g3.Zeni(g3,:)=results_norm.FS_error_Zeni(i,:);
            Error_values.IC.g3.Desailly(g3,:)=results_norm.FS_error_Desailly(i,:);
            Error_values.IC.g3.Hsue(g3,:)=results_norm.FS_error_Hsue(i,:);
            Error_values.IC.g3.Hreljac(g3,:)=results_norm.FS_error_Hreljac(i,:);
            Error_values.soleBeforeIC.g3(g3,:)=results_norm.soleAngle_beforeFS(i,:);
            g3=g3+1;
         elseif results_norm.soleAngle_beforeFS_grp(i)==4
            Error_values.IC.g4.Ghoussayni(g4,:)=results_norm.FS_error_Ghoussayni(i,:);
            Error_values.IC.g4.Zeni(g4,:)=results_norm.FS_error_Zeni(i,:);
            Error_values.IC.g4.Desailly(g4,:)=results_norm.FS_error_Desailly(i,:);
            Error_values.IC.g4.Hsue(g4,:)=results_norm.FS_error_Hsue(i,:);
            Error_values.IC.g4.Hreljac(g4,:)=results_norm.FS_error_Hreljac(i,:);
            Error_values.soleBeforeIC.g4(g4,:)=results_norm.soleAngle_beforeFS(i,:);
            g4=g4+1;
        end
    end

    % group based on varus angle before TO
    g1=1; g2=1;g3=1;g4=1;
    for i=1:length(results_norm.varusAngle_beforeFO_grp)
        if results_norm.varusAngle_beforeFO_grp(i)==1
            Error_values.TO.g1.Ghoussayni(g1,:)=results_norm.FO_error_Ghoussayni(i,:);
            Error_values.TO.g1.Zeni(g1,:)=results_norm.FO_error_Zeni(i,:);
            Error_values.TO.g1.Desailly(g1,:)=results_norm.FO_error_Desailly(i,:);
            Error_values.TO.g1.Hsue(g1,:)=results_norm.FO_error_Hsue(i,:);
            Error_values.TO.g1.Hreljac(g1,:)=results_norm.FO_error_Hreljac(i,:);
            Error_values.varusBeforeTO.g1(g1,:)=results_norm.varusAngle_beforeFO(i,:);
            g1=g1+1;
        elseif results_norm.varusAngle_beforeFO_grp(i)==2
            Error_values.TO.g2.Ghoussayni(g2,:)=results_norm.FO_error_Ghoussayni(i,:);
            Error_values.TO.g2.Zeni(g2,:)=results_norm.FO_error_Zeni(i,:);
            Error_values.TO.g2.Desailly(g2,:)=results_norm.FO_error_Desailly(i,:);
            Error_values.TO.g2.Hsue(g2,:)=results_norm.FO_error_Hsue(i,:);
            Error_values.TO.g2.Hreljac(g2,:)=results_norm.FO_error_Hreljac(i,:);
            Error_values.varusBeforeTO.g2(g2,:)=results_norm.varusAngle_beforeFO(i,:);
            g2=g2+1;
         elseif results_norm.varusAngle_beforeFO_grp(i)==3
            Error_values.TO.g3.Ghoussayni(g3,:)=results_norm.FO_error_Ghoussayni(i,:);
            Error_values.TO.g3.Zeni(g3,:)=results_norm.FO_error_Zeni(i,:);
            Error_values.TO.g3.Desailly(g3,:)=results_norm.FO_error_Desailly(i,:);
            Error_values.TO.g3.Hsue(g3,:)=results_norm.FO_error_Hsue(i,:);
            Error_values.TO.g3.Hreljac(g3,:)=results_norm.FO_error_Hreljac(i,:);
            Error_values.varusBeforeTO.g3(g3,:)=results_norm.varusAngle_beforeFO(i,:);
            g3=g3+1;
         elseif results_norm.varusAngle_beforeFO_grp(i)==4
            Error_values.TO.g4.Ghoussayni(g4,:)=results_norm.FO_error_Ghoussayni(i,:);
            Error_values.TO.g4.Zeni(g4,:)=results_norm.FO_error_Zeni(i,:);
            Error_values.TO.g4.Desailly(g4,:)=results_norm.FO_error_Desailly(i,:);
            Error_values.TO.g4.Hsue(g4,:)=results_norm.FO_error_Hsue(i,:);
            Error_values.TO.g4.Hreljac(g4,:)=results_norm.FO_error_Hreljac(i,:);
            Error_values.varusBeforeTO.g4(g4,:)=results_norm.varusAngle_beforeFO(i,:);
            g4=g4+1;
        end
    end
save([exportFolder '\errorValues_norms.mat'],'Error_values');

    %% Calculations difference
    % variables to consider for nested loops (sole & varus angles)
    Evaluated_angles = {'soleBeforeIC';'varusBeforeTO'};
    % statistics
    h=struct; p=struct;
    stats = struct;
    for i_angles=1:length(Evaluated_angles)
        Evaluated_groups = fieldnames(Error_values.(Evaluated_angles{i_angles,1}));
       for i_group=1:length(Evaluated_groups)
             [h.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1}),...
                 p.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1})]=...
                 kstest(Error_values.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1}),'Alpha',0.2); % normallity test 20 instead of 5%

             % as >90% of the to be evaluated groups were not normally
             % distributed, will proceed with just calculating nonparam
             % stats outcomes.

             % when normal:
             % bias= mean differences, Method A-Method B, eg. average of error values
             % limits of agreement (LoA), bias+/- 1.96*sd
%                  if h.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr) ==0
%                      stats.bias_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr)= mean(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr));
%                      stats.sd_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr) = std(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr));
%                      stats.loa_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr)=1.96*stats.sd_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr);
%                      
%                      CIFcn = @(x,p)std(x(:),'omitnan')/sqrt(sum(~isnan(x(:)))) * tinv(abs([0,1]-(1-p/100)/2),sum(~isnan(x(:)))-1) + mean(x(:),'omitnan'); %func to calculate 95%CI for norm data
%                      stats.CI_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr)= CIFcn(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr),95); 

                stats.mean.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1})= ...
                    mean(Error_values.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1}));
                stats.sd.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1}) = ...
                    std(Error_values.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1}));

             % when not normal:
             % bias= median of teh differences
             % limits of agreement (LoA), 2.5th and 97.5th percentiles
             % of the bias, eg. 95%CI
%                  elseif h.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr) ==1
                 stats.bias_nonp.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1})= ...
                    median(Error_values.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1}));
                 CIFcn = @(x,p)prctile(x,abs([0,100]-(100-p)/2));%func to calculate 95%CI for nonparameteric data
                 stats.loa_nonp.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1}) = ...
                     CIFcn(Error_values.(Evaluated_angles{i_angles,1}).(Evaluated_groups{i_group,1}),95); 

%                  end 
       end
    end

    % variables to consider for nested loops (events)
    Evaluated_events = {'IC';'TO'};
    Evaluated_methods = fieldnames(Error_values.IC.g1);
    Evaluated_markers = results_norm.nameMarkers';

%% Statistics
    % check normality of data distribution -
    % https://ch.mathworks.com/help/stats/kstest.html 
%     h=struct; p=struct;
    for i_nr=1:length(Evaluated_markers)
        for i_event=1:length(Evaluated_events)
            for i_method=1:length(Evaluated_methods)
               Evaluated_groups = fieldnames(Error_values.(Evaluated_events{i_event,1}));
               for i_group=1:length(Evaluated_groups)
                     [h.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr),p.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr)]=kstest(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr),'Alpha',0.2); % normallity test 20 instead of 5%

                     % as >90% of the to be evaluated groups were not normally
                     % distributed, will proceed with just calculating nonparam
                     % stats outcomes.

                     % when normal:
                     % bias= mean differences, Method A-Method B, eg. average of error values
                     % limits of agreement (LoA), bias+/- 1.96*sd
    %                  if h.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr) ==0
    %                      stats.bias_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr)= mean(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr));
    %                      stats.sd_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr) = std(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr));
    %                      stats.loa_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr)=1.96*stats.sd_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr);
    %                      
    %                      CIFcn = @(x,p)std(x(:),'omitnan')/sqrt(sum(~isnan(x(:)))) * tinv(abs([0,1]-(1-p/100)/2),sum(~isnan(x(:)))-1) + mean(x(:),'omitnan'); %func to calculate 95%CI for norm data
    %                      stats.CI_norm.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr)= CIFcn(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr),95); 

                        stats.mean.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr)= mean(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr));
                        stats.sd.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr) = std(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr));

                     % when not normal:
                     % bias= median of teh differences
                     % limits of agreement (LoA), 2.5th and 97.5th percentiles
                     % of the bias, eg. 95%CI
    %                  elseif h.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr) ==1
                         stats.bias_nonp.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr)= median(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr));
                         CIFcn = @(x,p)prctile(x,abs([0,100]-(100-p)/2));%func to calculate 95%CI for nonparameteric data
                         stats.loa_nonp.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr) = CIFcn(Error_values.(Evaluated_events{i_event,1}).(Evaluated_groups{i_group,1}).(Evaluated_methods{i_method,1})(:,i_nr),95); 

    %                  end 
               end
            end
        end
    end
    stats.h = h;
    stats.p = p;
save([exportFolder '\stats_norms.mat'],'stats');

% load('output\stats_norms.mat')

%% prepare plots
addpath('heatmap')
data = struct;
for e = 1:length(Evaluated_events)
    Evaluated_groups = fieldnames(Error_values.(Evaluated_events{e,1}));
    for g = 1:length(Evaluated_groups)
        for m = 1:length(Evaluated_methods)
            % define groups from mean error
            % cat = categorical({'<-6','[-6;-3[','[-3;3]',']3;6]','>6'});
            % cat =
            % categorical({'<-40','[-40;-20[','[-20;20]',']20;40]','>40'});
            % (in ms)
            % cat_vector = ["<-6","[-6;-3[","[-3;3]","]3;6]",">6"];
            % (in frames)
            data.(Evaluated_events{e,1}).(Evaluated_groups{g,1}).(Evaluated_methods{m,1}).histo = ...
                algo_count(Error_values.(Evaluated_events{e,1}).(Evaluated_groups{g,1}).(Evaluated_methods{m,1}));
            % order values into topographical location for heatmap visualization
            data.(Evaluated_events{e,1}).(Evaluated_groups{g,1}).(Evaluated_methods{m,1}).Heatmap = ...
                OrderHeatmap_Marie(stats.bias_nonp.(Evaluated_events{e,1}).(Evaluated_groups{g,1}).(Evaluated_methods{m,1}));
        end
    end
end

%% Plot data
% % plot top and side view of error values
view = {'top','side'};
% for e = 1:length(Evaluated_events)
%     Evaluated_groups = fieldnames(data.(Evaluated_events{e,1}));
%     for g = 1:length(Evaluated_groups)
%         for v = 1: length(view)
%             Fig1=figure('PaperSize',[21 29.7],'Units','centimeters','WindowState','maximized');
%             createFig(Fig1,['Norm - ' Evaluated_events{e,1} ' - ' Evaluated_groups{g,1} ' - ' view{1,v} ' view'],...
%                 data.(Evaluated_events{e,1}).(Evaluated_groups{g,1}),view{1,v});
%             savefig(Fig1,['heatmap/figures/norm/heatmap_' Evaluated_events{e,1} '_' Evaluated_groups{g,1} '_' view{1,v} 'View.fig']);
%             saveas(Fig1,['heatmap/figures/norm/heatmap_' Evaluated_events{e,1} '_' Evaluated_groups{g,1} '_' view{1,v} 'View.jpg']);
%             close(Fig1)
%         end
%     end
% end
% plot and save histogramms of error values
for e = 1:length(Evaluated_events)
    Evaluated_groups = fieldnames(data.(Evaluated_events{e,1}));
    for g = 1:length(Evaluated_groups)
            Fig1=figure('PaperSize',[21 29.7],'Units','centimeters','WindowState','maximized');
            createHisto(Fig1,['Norm - ' Evaluated_events{e,1} ' - ' Evaluated_groups{g,1}],...
                data.(Evaluated_events{e,1}).(Evaluated_groups{g,1}));
            savefig(Fig1,[exportFolder '/heatmap/figures/norm/histo_' Evaluated_events{e,1} '_' Evaluated_groups{g,1} '.fig']);
            saveas(Fig1,[exportFolder '/heatmap/figures/norm/histo_' Evaluated_events{e,1} '_' Evaluated_groups{g,1} '.jpg']);
            close(Fig1)
    end
end

% plot and save heatmaps seperataly
for e = 1:length(Evaluated_events)
    Evaluated_groups = fieldnames(data.(Evaluated_events{e,1}));
    for g = 1:length(Evaluated_groups)
        for v = 1: length(view)
            Fig1=figure('PaperSize',[21 29.7],'Units','centimeters','WindowState','maximized');
            createFig_heatmap(Fig1, ...
                ['Norm - ' Evaluated_events{e,1} ' - ' Evaluated_groups{g,1} ' - ' view{1,v} ' view - median'],...
                data.(Evaluated_events{e,1}).(Evaluated_groups{g,1}),view{1,v});
            savefig(Fig1,[exportFolder '/heatmap/figures/norm/heatmapOnly_' Evaluated_events{e,1} '_' Evaluated_groups{g,1} '_' view{1,v} 'View_median.fig']);
            saveas(Fig1,[exportFolder '/heatmap/figures/norm/heatmapOnly_' Evaluated_events{e,1} '_' Evaluated_groups{g,1} '_' view{1,v} 'View_median.jpg']);
            saveas(Fig1,[exportFolder '/heatmap/figures/norm/heatmapOnly_' Evaluated_events{e,1} '_' Evaluated_groups{g,1} '_' view{1,v} 'View_median.tif']);
            close(Fig1)
        end
    end
end