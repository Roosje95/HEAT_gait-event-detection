% define gait events (foot strike and foot off) from Zeni method
% input:
% - marker: 3D coordinates of a foot marker
% - pelvicMk: a struct of the 5 pelvic markers (LASI; RASI; LPSI; RPSI;
% SACR)
% - gaitAxis: number of the gait axis: 1=x, 2=y
%
% output:
% - FS = array of foot strikes
% - FO = array of foot offs
function [FS,FO] = Zeni(marker,pelvicMk,gaitAxis)
% -------------------------------------------------------------------------
% Initialisation
% -------------------------------------------------------------------------
FS = [];
FO = [];

% -------------------------------------------------------------------------
% Detect events using the relative displacement of the marker to the pelvis
% -------------------------------------------------------------------------
% % relative to the pelvis origin, on the ant/posterior axis of the pelvis
% % (Adapted from SOFAMEAhack2020)
%     for frame=1:n
%         for t=1:3
%             OrPelvis(frame,t) = ((pelvicMk.filtLPSI(frame,t)+pelvicMk.filtRPSI(frame,t))/2+(pelvicMk.filtLASI(frame,t)+pelvicMk.filtRASI(frame,t))/2)/2;
%             yPelvis(frame,t) = (pelvicMk.filtLASI(frame,t)+pelvicMk.filtRASI(frame,t))/2-(pelvicMk.filtLPSI(frame,t)+pelvicMk.filtRPSI(frame,t))/2;
%         end
%     end
%     yPelvis(:,verticalAxis) = zeros(n,1);
%     rel2pelvicOrig = dot(yPelvis,marker-OrPelvis,2);
%     
%     [~,FS] = findpeaks(rel2pelvicOrig);
%     [~,FO] = findpeaks(-rel2pelvicOrig);
                
% relative to the sacrum marker
% (from Zeni paper)
    rel2sacr = marker(:,gaitAxis)-pelvicMk.filtSACR(:,gaitAxis);

    [pk_values,FS_] = findpeaks(rel2sacr,'MinPeakHeight',mean(rel2sacr));
    % minimum 30 frames (150Hz) between 2 peaks, if not takes the index
    % with the greatest peak
    indexFS = 1;
    i=1;
    while i<=length(FS_)
        if i==length(FS_)
            FS(indexFS) = FS_(i);
            i = i + 1;
        else
            if FS_(i+1)-FS_(i) > 30
                FS(indexFS) = FS_(i);
                indexFS = indexFS + 1;
                i = i + 1;
            else
                [~,max_ind] = max([pk_values(i) pk_values(i+1)]);
                FS(indexFS) = FS_(i + max_ind -1);
                indexFS = indexFS + 1;
                i = i + 2;
            end
        end
    end
    [pk_values,FO_] = findpeaks(-rel2sacr,'MinPeakHeight',mean(-rel2sacr));
    % minimum 30 frames (150Hz) between 2 peaks, if not takes the index
    % with the greatest peak
    indexFO = 1;
    i=1;
    while i<=length(FO_)
        if i==length(FO_)
            FO(indexFO) = FO_(i);
            i = i + 1;
        else
            if FO_(i+1)-FO_(i) > 30
                FO(indexFO) = FO_(i);
                indexFO = indexFO + 1;
                i = i + 1;
            else
                [~,max_ind] = max([pk_values(i) pk_values(i+1)]);
                FO(indexFO) = FO_(i + max_ind -1);
                indexFO = indexFO + 1;
                i = i + 2;
            end
        end
    end

