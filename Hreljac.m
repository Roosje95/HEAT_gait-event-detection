% define gait events (foot strike and foot off) from Hreljac method
% input:
% - footMk: 3D coordinates of a foot marker
% - pelvicMk: a struct of the 5 pelvic markers (LASI; RASI; LPSI; RPSI;
% SACR)
% - gaitAxis: number of the gait axis: 1=x, 2=y
% - verticalAxis: number of the vertical axis (3=z)
% - f: frequence
%
% output:
% - FS = array of foot strikes
% - FO = array of foot offs
function [FS,FO] = Hreljac(footMk,pelvicMk,gaitAxis,verticalAxis,f)
FS = [];
FO = [];
% -------------------------------------------------------------------------
    % Foot strike
    % jerk of the marker in the vertical component = 0
% -------------------------------------------------------------------------
    velZ_footMk = diff(footMk(:,verticalAxis))/(1/f);
    accZ_footMk = diff(velZ_footMk)/(1/f);
    jerkZ_footMk = diff(accZ_footMk)/(1/f);
    
    % define the events from Zeni
    [FS_zeni,FO_zeni] = Zeni(footMk,pelvicMk,gaitAxis);
    
    % define a window about the FS of Zeni: [-f*35/150 f*35/150], i.e. +/- 35 frames
    % by 150 Hz
    
    % find the nearest max peak of acceleration of the vertical component
    % (= first zero of the jerk, positiv to negativ) to Zeni in the defined
    % window
    for i=1:length(FS_zeni)
        indJerk = max(FS_zeni(i) - f*35/150,1);
        maxLength = min(FS_zeni(i)+f*35/150,length(jerkZ_footMk));
        j=1;
        while indJerk<maxLength
            while ( indJerk<maxLength && jerkZ_footMk(indJerk)<=0 )
                indJerk = indJerk + 1;
            end % indJerk=maxLength or jerkZ_footMk(indJerk)>0
            while ( indJerk<maxLength && jerkZ_footMk(indJerk+1)>=0 )
                indJerk = indJerk + 1;
            end % indJerk=maxLength or jerkZ_footMk(indJerk+1)<0
            if indJerk < maxLength % i.e. jerkZ_footMk(indJerk+1)<0
                t2 = indJerk + 1;
                if jerkZ_footMk(indJerk)>0
                    t1 = indJerk;
                else % jerkZ_footMk(indJerk)=0
                    while jerkZ_footMk(indJerk)==0
                        indJerk = indJerk - 1;
                    end % jerkZ_footMk(indJerk)>0
                    t1 = indJerk;
                end
            else % indJerk >= maxLength
                t1 = NaN;
                t2 = NaN;
            end
            if ~isnan(t1) && ~isnan(t2)
                local_jerk_zero(j) = t1 + jerkZ_footMk(t1) / (jerkZ_footMk(t1)-jerkZ_footMk(t2));
            else
                local_jerk_zero(j) = NaN;
            end
            j=j+1;
            indJerk = indJerk + 1;
        end
        [~,min_index] = min(abs(local_jerk_zero - FS_zeni(i)));
        FS(i) = local_jerk_zero(min_index);
    end
    
% -------------------------------------------------------------------------
    % Foot Off
    % jerk of the marker in the gait direction
% -------------------------------------------------------------------------
    velX_footMk = diff(footMk(:,gaitAxis))/(1/f);
    accX_footMk = diff(velX_footMk)/(1/f);
    jerkX_footMk = diff(accX_footMk)/(1/f);
    
    % define the max of acceleration in a window about the FO_zeni events
    % ([-f*35/150 f*35/150])
    for i=1:length(FO_zeni)
        begin_ = max(1,FO_zeni(i)-f*35/150);
        end_ = min(length(accX_footMk),FO_zeni(i)+f*35/150);
        [~,ind_max_accX] = max(accX_footMk(begin_:end_));
        % find the zero of jerk corresponding to this max (search from this
        % max - f/15 frames (10 frames by 150 Hz))
        indJerk = max(1,begin_ + ind_max_accX - f/15);
        while ( indJerk<length(jerkX_footMk) && jerkX_footMk(indJerk)<=0 )
            indJerk = indJerk + 1;
        end % indJerk=length(jerkX_footMk) or jerkX_footMk(indJerk)>0
        while ( indJerk<length(jerkX_footMk) && jerkX_footMk(indJerk+1)>=0 )
            indJerk = indJerk + 1;
        end % indJerk=length(jerkX_footMk) or jerkX_footMk(indJerk+1)<0
        if indJerk < length(jerkX_footMk) % i.e. jerkX_footMk(indJerk+1)<0
            t2 = indJerk + 1;
            if jerkX_footMk(indJerk)>0
                t1 = indJerk;
            else % jerkX_footMk(indJerk)=0
                while jerkX_footMk(indJerk)==0
                    indJerk = indJerk - 1;
                end % jerkX_footMk(indJerk)>0
                t1 = indJerk;
            end
        else % indJerk >= length(jerkX_footMk)
            t1 = NaN;
            t2 = NaN;
        end
        if ~isnan(t1) && ~isnan(t2)
            FO(i) = t1 + jerkX_footMk(t1) / (jerkX_footMk(t1)-jerkX_footMk(t2));
        else
            FO(i) = NaN;
        end
    end
    
    