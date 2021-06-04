% function to get the sole angle form the c3d data and to calculate the mean
% values of this angle before the FS and over the midstance
% Input:
% - btkData = btk handle of the c3d file
% - side: leg side ('L' or 'R')
% - FS = foot strike (in frames by 150 Hz)
% - FO = foot off (in frames by 150 Hz)
%
% Output:
% - soleAng_beforeFS = mean of the sole angle 5 frames (by 150Hz) before FS
% - soleAng_midStance = mean of the sole angle over the midstance

function [soleAng_beforeFS,soleAng_midStance] = getSoleAngle(btkData,side,FS,FO)

    Angles = btkGetAngles(btkData);
    f = btkGetPointFrequency(btkData);
    n = btkGetPointFrameNumber(btkData);
    
    % Butterworth filter, zero-phase filter, 2nd order, low-pass, cut-off 10 Hz
    [B,A] = butter(2,10/(f/2),'low');

    %% sole angle
    % so as to have foot flat = 0° => add 90°
    % filtered as the markers
    sole_angle1 = filtfilt(B, A, -(Angles.([side 'FootProgressAngles'])(:,1)+90));
    if f == 300
        sole_angle = interpft(sole_angle1,round(n/2));
    else
        sole_angle = sole_angle1;
    end
    clear sole_angle1

    % define the time were the foot has to be flat for healthy subjects (mid-stance)
    sole_angle_st_normalised = normalised101(sole_angle,[FS FO]);
    % midStance = 10-30% of gait cycle, stance phase = 60%
    % => midStance = 17-50% of stance phase
    % normalisation: first frame = 0%, last frame (101) = 100%
    % => 17% = frame 17+1, 50% = frame 50+1
    soleAng_midStance = mean(sole_angle_st_normalised(17+1:50+1));

    % mean of the sole angle 5 frames (by 150Hz) before FS
    soleAng_beforeFS = mean(sole_angle(FS-5+1:FS));