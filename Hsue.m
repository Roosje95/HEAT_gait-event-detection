% define gait events (foot strike and foot off) from Hsue method
% input:
% - footMk: 3D coordinates of a foot marker
% - pelvicMk: a struct of the 5 pelvic markers (LASI; RASI; LPSI; RPSI;
% SACR)
% - gaitAxis: number of the gait axis: 1=x, 2=y
% - f: frequence
%
% output:
% - FS = array of foot strikes
% - FO = array of foot offs
function [FS,FO] = Hsue(footMk,pelvicMk,gaitAxis,f)
% -------------------------------------------------------------------------
    % velocity and acceleration of the marker in the gait direction
% -------------------------------------------------------------------------
    vel_footMk = diff(footMk(:,gaitAxis))/(1/f);
    acc_footMk =diff(vel_footMk)/(1/f);
% -------------------------------------------------------------------------
    % foot strike = minimum of foot marker acceleration
% -------------------------------------------------------------------------
%     [~,FS] = findpeaks(-acc_footMk,'MinPeakHeight',max(-acc_footMk(10:end-10))/2);
    % in the max: take back the 10 first and last frames because of extrem
    % values at the edge of the signal
    % threshold visually determined from norm data
    % sometimes too many peaks -> use a window about Zeni
    
    % define the events from Zeni
    [FS_zeni,FO_zeni] = Zeni(footMk,pelvicMk,gaitAxis);

    % find the greatest peak of acceleration (in a window from -f*35/150 to f*35/150
    % around the peaks from Zeni)
    for i=1:length(FS_zeni)
        begin_ = max(1,FS_zeni(i)-f*35/150);
        end_ = min(length(acc_footMk),FS_zeni(i)+f*35/150);
        [~,index_maxLocal] = max(-acc_footMk(begin_:end_));
        FS(i) = index_maxLocal + begin_ - 1;
    end

% -------------------------------------------------------------------------
    % foot off = maximum of foot marker acceleration
% -------------------------------------------------------------------------
%     [~,FO] = findpeaks(acc_footMk); % too many peaks => use a window
    
    % find the greatest peak of acceleration (in a window from -f*35/150 to f*35/150
    % around the peaks from Zeni)
    for i=1:length(FO_zeni)
        begin_ = max(1,FO_zeni(i)-f*35/150);
        end_ = min(length(acc_footMk),FO_zeni(i)+f*35/150);
        [~,index_maxLocal] = max(acc_footMk(begin_:end_));
        FO(i) = index_maxLocal + begin_ - 1;
    end

