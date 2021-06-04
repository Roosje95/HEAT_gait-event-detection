% define gait events (foot strike and foot off) from Ghoussayni method
% threshold on 500 mm/s (Bruening 2014)
% input:
% - marker: 3D coordinates of a foot marker
% - pelvicMk: a struct of the 5 pelvic markers (LASI; RASI; LPSI; RPSI;
% SACR)
% - gaitAxis: number of the gait axis: 1=x, 2=y
% - verticalAxis: number of the vertical axis (3=z)
% - n: number of frames
% - f: frequency of the data (markers)
%
% output:
% - FS = array of foot strikes
% - FO = array of foot offs
function [FS,FO] = Ghoussayni(marker,pelvicMk,gaitAxis,verticalAxis,n,f)
% -------------------------------------------------------------------------
% Initialisation
% -------------------------------------------------------------------------
FS = [];
FO = [];

% -------------------------------------------------------------------------
% Calculate the 2D velocity of the marker in the plane containing
% gait (V1) and vertical (V2) axes
% -------------------------------------------------------------------------
% marker velocity
for t = 1:n-1
    velocity(t) = sqrt((marker(t+1,gaitAxis)- ...
        marker(t,gaitAxis))^2+ ...
        (marker(t+1,verticalAxis)- ...
        marker(t,verticalAxis))^2)/ ...
        (1/f);
end

% -------------------------------------------------------------------------
% Velocity threshold (empirically set)
% 50 mm/s in the original article for barefoot gait
% 500 mm/s in Bruening et al., 2014
% -------------------------------------------------------------------------
vThreshold = 500;

% define the events from Zeni
[FS_zeni,FO_zeni] = Zeni(marker,pelvicMk,gaitAxis);
    
% -------------------------------------------------------------------------
% Detect events using the velocity threshold
%   The event is defined when the marker has a velocity under
%   threshold for FS, over threshold for FO
% -------------------------------------------------------------------------

% find the events in a window around the event from Zeni ([-f*35/150 f*35/150], i.e. 
% +/- 35 frames by 150 Hz) (take the nearest one)
for i=1:length(FS_zeni)
    indVel = max(FS_zeni(i) - f*35/150,1);
    maxLength = min(FS_zeni(i)+f*35/150,length(velocity));
    j=1;
    while indVel<maxLength
        while ( indVel<maxLength && velocity(indVel)<=vThreshold )
            indVel = indVel + 1;
        end % indVel=maxLength or velocity(indVel)>vThreshold
        while ( indVel<maxLength && velocity(indVel+1)>=vThreshold )
            indVel = indVel + 1;
        end % indVel=maxLength or velocity(indVel+1)<vThreshold
        if indVel < maxLength % i.e. velocity(indVel+1)<vThreshold
            t1 = indVel+1;
        else % indVel >= maxLength
            t1 = NaN;
        end
        if ~isnan(t1)
            local_FS(j) = t1;
        else
            local_FS(j) = NaN;
        end
        j=j+1;
        indVel = indVel + 1;
    end
    [~,min_index] = min(abs(local_FS - FS_zeni(i)));
    FS(i) = local_FS(min_index);
end

for i=1:length(FO_zeni)
    indVel = max(FO_zeni(i) - f*35/150,1);
    maxLength = min(FO_zeni(i)+f*35/150,length(velocity));
    j=1;
    while indVel<maxLength
        while ( indVel<maxLength && velocity(indVel)>=vThreshold )
            indVel = indVel + 1;
        end % indVel=maxLength or velocity(indVel)<vThreshold
        while ( indVel<maxLength && velocity(indVel+1)<=vThreshold )
            indVel = indVel + 1;
        end % indVel=maxLength or velocity(indVel+1)>vThreshold
        if indVel < maxLength % i.e. velocity(indVel+1)>vThreshold
            t1 = indVel+1;
        else % indVel >= maxLength
            t1 = NaN;
        end
        if ~isnan(t1)
            local_FO(j) = t1;
        else
            local_FO(j) = NaN;
        end
        j=j+1;
        indVel = indVel + 1;
    end
    [~,min_index] = min(abs(local_FO - FO_zeni(i)));
    FO(i) = local_FO(min_index);
end
    