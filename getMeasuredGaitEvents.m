% determine the measured events from a given c3d, threshold given as input
% input:
% - btkData: btk handle of the c3d file
% - FP_number: forceplate number where the measured events are determined
% - threshold: force threshold (N) ofr the detection of the events
%
% output: (=NaN if not found)
% - mFS = measured foot strike from forceplate
% - mFO = measured foot off from forceplate
function [mFS,mFO] = getMeasuredGaitEvents(btkData,FP_number,threshold)

% frequencies
f = btkGetPointFrequency(btkData);
n = btkGetPointFrameNumber(btkData);

% Compare determined results (from  some algorithm) with forceplate data (up to 4 FPs)
GRF = btkGetGroundReactionWrenches(btkData);
if f == 300 % set 300Hz data to 150 Hz
    Force_z = interpft(GRF(FP_number).F(:,3),round(n/2)); % Z axis (vertical)
else
    Force_z = interpft(GRF(FP_number).F(:,3),n); % Z axis (vertical)
end
clear GRF

% FS from forceplate
mFS = NaN;
% check for Force_z>threshold during 5 kinematics frames
indexAnalog = 1;
while (indexAnalog < length(Force_z)) && isnan(mFS)
    if Force_z(indexAnalog) >= threshold
        % test if the force is >= threshold during 5 kinematics frames
        t = 1;
        FS_OK = 1;
        while FS_OK && t<5%*freqAnalog/freqKinematics)
            if Force_z(indexAnalog+t)>=threshold
                FS_OK = 1;
            else
                FS_OK = 0;
            end
            t = t + 1;
        end
        if FS_OK
            mFS = indexAnalog;
        end
    end
    indexAnalog = indexAnalog + 1;
end


% FO from forceplate
mFO = NaN;
if ~isnan(mFS)
    mFO = find(Force_z(mFS:end)<threshold,1)+mFS-1; % first index with Fz< threshold N on Z axis (vertical)
end
