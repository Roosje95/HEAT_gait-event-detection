% function to calculate the varus angle from the DMT1&5 markers and the
% mean values of this angle before the FS and over the midstance
% Input:
% - DMT1 = 3D coordinates of the distal metatarsal I marker (rotated to gait
% direction in 1st axis)
% - DMT5 = 3D coordinates of the distal metatarsal V marker (rotated to gait
% direction in 1st axis)
% - FS = foot strike (in frames)
% - FO = foot off (in frames)
%
% Output:
% - varusAng_beforeFS = mean of the varus angle 5 frames (by 150Hz) before FS
% - varusAng_beforeFO = mean of the varus angle 5 frames (by 150Hz) before FO
% - varusAng_midStance = mean of the varus angle over the midstance

function [varusAng_beforeFS,varusAng_beforeFO,varusAng_midStance] = getVarusAngle(DMT1,DMT5,FS,FO)

    %% varus angle
    for i=1:length(DMT1)
        varusAng(i,1) = (180/pi)*asin((DMT1(i,3)-DMT5(i,3))/...
                        sqrt((DMT1(i,2)-DMT5(i,2))^2 + (DMT1(i,3)-DMT5(i,3))^2));
    end
    
    % define the time were the foot has to be flat for healthy subjects (mid-stance)
    varusAng_st_normalised = normalised101(varusAng,[FS FO]);
    % midStance = 10-30% of gait cycle, stance phase = 60%
    % => midStance = 17-50% of stance phase
    % normalisation: first frame = 0%, last frame (101) = 100%
    % => 17% = frame 17+1, 50% = frame 50+1
    varusAng_midStance = mean(varusAng_st_normalised(17+1:50+1));

    % mean of the sole angle 5 frames (by 150Hz) before FS
    varusAng_beforeFS = mean(varusAng(FS-5+1:FS));

    % mean of the sole angle 5 frames (by 150Hz) before FO
    varusAng_beforeFO = mean(varusAng(FO-5+1:FO));



