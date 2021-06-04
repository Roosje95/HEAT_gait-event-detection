% define gait events (foot strike and foot off) from Desailly method
% input:
% - heelMk: non filtered 3D coordinates of heel marker (for gait frequency)
% - footMk: non filtered 3D coordinates of a foot marker
% - pelvicMk: a struct of the 5 pelvic markers (LASI; RASI; LPSI; RPSI;
% SACR)
% - gaitAxis: number of the gait axis: 1=x, 2=y
% - verticalAxis: number of the vertical axis (3=z)
% - f: frequence
%
% output:
% - FS = array of foot strikes
% - FO = array of foot offs
function [FS,FO] = Desailly(heelMk,footMk,pelvicMk,gaitAxis,verticalAxis,f)
% -------------------------------------------------------------------------
    % 4th order butterworth lowpass filter (7 Hz)
% -------------------------------------------------------------------------
    [B,A] = butter(4,(7/(f/2)));
    filtered_marker = filtfilt(B, A, footMk);
    filt_heelMk = filtfilt(B, A, heelMk);

% -------------------------------------------------------------------------
    % determine the gait frequency from the vertical component of the heel marker
    % do not work with the other markers: displacements have too many peaks
% -------------------------------------------------------------------------
    [~,frame_pks]=findpeaks(filt_heelMk(:,verticalAxis),'MinPeakHeight',100); %25 is too low for the norm data
    if length(frame_pks)<2 % not enough peaks: try with the minimum peaks
        [~,frame_pks]=findpeaks(-filt_heelMk(:,verticalAxis),'MinPeakHeight',-100);
    end
    stridetime=(frame_pks(2)-frame_pks(1))/f;
    gaitFreq = 1/stridetime;
    clear stridetime frame_pks
    
% -------------------------------------------------------------------------
    % highpass filter (0.5*gait frequency) of the horizontal component of the marker
% -------------------------------------------------------------------------
    [z,p,k] = butter(4,((0.5*gaitFreq)/(f/2)),'high');
    [sos,g] = zp2sos(z,p,k);
    highPass_mk_FS  = filtfilt(sos,g,filtered_marker(:,gaitAxis));
    
    % define the events from Zeni
    [FS_zeni,FO_zeni] = Zeni(footMk,pelvicMk,gaitAxis);

    for i=1:length(FS_zeni)
        begin_ = max(1,FS_zeni(i)-f*35/150);
        end_ = min(length(highPass_mk_FS),FS_zeni(i)+f*35/150);
        [~,index_maxLocal] = findpeaks(highPass_mk_FS(begin_:end_));
        if ~isnan(index_maxLocal)
            [~,min_index] = min(abs(index_maxLocal - f*35/150));
            FS(i) = index_maxLocal(min_index) + begin_ - 1;
        else
            FS(i) = NaN;
        end
    end


% % -------------------------------------------------------------------------
%     % original: highpass filter (1.1*gait frequency) of the horizontal component of the marker
% % -------------------------------------------------------------------------
%     [z2,p2,k2] = butter(4,((1.1*gaitFreq)/(f/2)),'high');
%     [sos2,g2] = zp2sos(z2,p2,k2);
%     highPass_mk_FO  = filtfilt(sos2,g2,filtered_marker(:,gaitAxis));
%     [~,FO] = findpeaks(-highPass_mk_FO);
    
% -------------------------------------------------------------------------
    % Bruening & Goncalves proposed 0.5*gait frequency for the FO:
% -------------------------------------------------------------------------
    for i=1:length(FO_zeni)
        begin_ = max(1,FO_zeni(i)-f*35/150);
        end_ = min(length(highPass_mk_FS),FO_zeni(i)+f*35/150);
        [~,index_maxLocal] = findpeaks(-highPass_mk_FS(begin_:end_));
        
        if ~isnan(index_maxLocal)
            [~,min_index] = min(abs(index_maxLocal - f*35/150));
            FO(i) = index_maxLocal(min_index) + begin_ - 1;
        else
            FO(i) = NaN;
        end
    end

