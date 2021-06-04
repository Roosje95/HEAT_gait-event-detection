% function to extract from the c3d data the listed markers, to rotate them
% so that the x-axis (1st axis) is the gait direction, to filtered them
% Input:
% - btkData = btk handle of the c3d file
% - n: number of frames
% - f: frequency of the data (markers)
% - side: leg side ('L' or 'R')
% - MarkersName = list of the markers, without the side information
%
% Output:
% - nonfiltered_markers = rotated markers non filtered
% - filtered_markers = rotated markers filtered
% - pelvicMk = all pelvic markers, filtered
function [nonfiltered_markers,filtered_markers,pelvicMk] = ...
            getMarkers(btkData,side,MarkersName)
    
    Markers = btkGetMarkers(btkData);
    f = btkGetPointFrequency(btkData);
    n = btkGetPointFrameNumber(btkData);
    
    %% rotate the markers to the gait axis
    markers_corrected = f_rotCoordinateSystem(Markers);

    %% Filter 3D trajectories of markers
    % set 300Hz data to 150 Hz
    % Butterworth filter, zero-phase filter, 2nd order, low-pass, cut-off 10 Hz
    [B,A] = butter(2,10/(f/2),'low');
    nonfiltered_markers = [];
    filtered_markers = [];
    for i = 1:length(MarkersName)
        if f == 300
            nonfiltered_markers(:,:,i) = interpft(markers_corrected.([side MarkersName{1,i}]),round(n/2));
            filt_marker_i = filtfilt(B, A, markers_corrected.([side MarkersName{1,i}]));
            filtered_markers(:,:,i) = interpft(filt_marker_i,round(n/2));
            clear filt_marker_i
        else
            nonfiltered_markers(:,:,i) = markers_corrected.([side MarkersName{1,i}]);
            filtered_markers(:,:,i) = filtfilt(B, A, nonfiltered_markers(:,:,i));
        end
    end
    
    if f == 300
        filt_marker = filtfilt(B, A, markers_corrected.LASI);
        pelvicMk.filtLASI = interpft(filt_marker,round(n/2));
        filt_marker = filtfilt(B, A, markers_corrected.RASI);
        pelvicMk.filtRASI = interpft(filt_marker,round(n/2));
        filt_marker = filtfilt(B, A, markers_corrected.LPSI);
        pelvicMk.filtLPSI = interpft(filt_marker,round(n/2));
        filt_marker = filtfilt(B, A, markers_corrected.RPSI);
        pelvicMk.filtRPSI = interpft(filt_marker,round(n/2));
        filt_marker = filtfilt(B, A, markers_corrected.SACR);
        pelvicMk.filtSACR = interpft(filt_marker,round(n/2));
    else
        pelvicMk.filtLASI = filtfilt(B, A, markers_corrected.LASI);
        pelvicMk.filtRASI = filtfilt(B, A, markers_corrected.RASI);
        pelvicMk.filtLPSI = filtfilt(B, A, markers_corrected.LPSI);
        pelvicMk.filtRPSI = filtfilt(B, A, markers_corrected.RPSI);
        pelvicMk.filtSACR = filtfilt(B, A, markers_corrected.SACR);
    end