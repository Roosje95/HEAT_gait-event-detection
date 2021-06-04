%{ 
*********************************************************************************
Function "f_rotCoordinateSystem" linked to script "Auswertung_mitFormularen"
              run from "f_correctGaitDirection
                by Sebastian Krapf Feb. 2014
*********************************************************************************

Change coordinate system from vicon xyz to x'y'z'
Walking direktion gets positive x' (1)
Medio lateral = y'
Vertical stays z

Gets names for video (e.g. "AP anterior")

INPUT: markers = Struct with markers as output from c3d

OUTPUT: markers_corrected = struct with markers/forces, where x = walking direction,
                                   y = medio-lateral, z = vertical
        videoFront/videoSagitt = New names for videos e.g. "Sagittal_right"
%}

% function [markers,videoFront,videoSagitt] = f_rotCoordinateSystem(markers, walkdir, i)
function markers_corrected = f_rotCoordinateSystem(markers)
    SACR = markers.SACR;
    
    dir_i = abs(SACR(end, 1) - SACR(1, 1)); 
    dir_j = abs(SACR(end, 2) - SACR(1, 2)); 
    
    walkdir = 1;  % x is walkdir
    if (dir_i < dir_j)  
        walkdir = 2;  % y is walkdir
    end
    % pos. or neg. direktion on axis
    sgn = sign(SACR(end, walkdir) - SACR(1, walkdir));
    walkdir = walkdir * sgn;
    
    switch (walkdir)
        case 1 % case x+
            walksign = 1;
            saggdir = 2;
            saggsgn = 1;
%             videoFront = 'Sagittal_right';
%             videoSagitt = 'AP_posterior';
        case -2 % case y-
            walkdir = 2;
            walksign = -1;
            saggdir = 1;
            saggsgn = 1;
%             videoFront = 'AP_anterior';
%             videoSagitt = 'Sagittal_right';
        case -1 % case x-
            walkdir = 1;
            walksign = -1;
            saggdir = 2;
            saggsgn = -1;
%             videoFront = 'Sagittal_left';
%             videoSagitt = 'AP_anterior';
        case 2 % case y+
            walksign = 1;
            saggdir = 1;  
            saggsgn = -1;
%             videoFront = 'AP_posterior';
%             videoSagitt = 'Sagittal_left';
    end
    
    mkNames = fieldnames(markers);                                                                                                                            

    for j = 1 : length(mkNames)                                                                                                                                               
        markers_corrected.(mkNames{j}) = [walksign * markers.(mkNames{j})(:, walkdir) ...
                          saggsgn * markers.(mkNames{j})(:, saggdir) ...
                                    markers.(mkNames{j})(:, 3)];                                                                                                 
    end                                                                                                                                                        
end  %FUNCTION f_rotCoordinateSystem    
