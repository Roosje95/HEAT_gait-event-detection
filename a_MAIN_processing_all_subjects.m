% Turn warnings off
warning('off','MATLAB:interp1:NaNinY')
clear all

%% Set folders
% btkFolder     = 'C:\Users\FreslierM\Documents\MATLAB\btk';
% addpath(btkFolder);
dataFolder = 'C:\Users\FreslierM\Documents\Forschung_Projekte_UKBB\automatisiertenEvents\projekt_19_20\daten';
exportFolder  = 'C:\Users\FreslierM\Desktop\output';

% -------------------------------------------------------------------------
%% Set Marker names
% -------------------------------------------------------------------------
FootMarkersName = { 'HEE' 'TPR' 'SITA' 'ANK'...
                    'PMT1' 'PMT5' 'CUN' ...
                    'DMT1' 'DMT5' 'TOE' 'HLX'};
R_FootMarkersName = { 'RHEE' 'RTPR' 'RSITA' 'RANK'...
                      'RPMT1' 'RPMT5' 'RCUN' ...
                      'RDMT1' 'RDMT5' 'RTOE' 'RHLX'};
L_FootMarkersName = { 'LHEE' 'LTPR' 'LSITA' 'LANK'...
                      'LPMT1' 'LPMT5' 'LCUN' ...
                      'LDMT1' 'LDMT5' 'LTOE' 'LHLX'};

%% Define gait and vertical axes
gaitAxis = 1; % X axis
verticalAxis = 3; % Z axis vertical

% -------------------------------------------------------------------------
%% healthy subjects
% -------------------------------------------------------------------------
subjectFolder = [dataFolder '\NormSubjects'];
%% hold the description of the data
T = readtable([subjectFolder '\norm_description.xlsx']);
left = T.left;
right = T.right;
subjects = T.Number;
clear T

results_norm.nameMarkers = FootMarkersName;

%% subjects
for subj= 1:size(subjects,1)
    dataStr = subjects{subj,1}; % subject name
    if ~isempty(dataStr)
        side = {'L' 'R'};
        for s = 1:length(side)
            results_norm.nameSubjects{(subj-1)*2+s,1} = [dataStr '_' side{1,s}];
            % informations of the side from excel sheet
            switch(side{1,s})
                case 'L'
                    infoSide = left{subj,1};
                case 'R'
                    infoSide = right{subj,1};
            end
            textSplit = regexp(infoSide,'Tr \d*| FP \d','match');
            trialCell = regexp(textSplit{1,1},'\d*','match');
            trial = str2num(trialCell{1,1});
            fpCell = regexp(textSplit{1,2},'\d*','match');
            
            %% path of the c3d
            if trial <= 9
                c3dPath = [subjectFolder '\walkNorm_' dataStr 'a0' trialCell{1,1} '.c3d'];
            else
                c3dPath = [subjectFolder '\walkNorm_' dataStr 'a' trialCell{1,1} '.c3d'];
            end

            clear textSplit trialCell trial infoSide
            
            %% Load C3D data
            btkData = btkReadAcquisition(c3dPath);
            
            %% load, rotate, filter markers
            [nonfiltered_markers,filtered_markers,pelvicMk] = getMarkers(btkData,side{1,s},FootMarkersName);
            
            %% Get gait events measured using forceplates
            [mFS,mFO] = getMeasuredGaitEvents(btkData,str2num(fpCell{1,1}),20);
            
            %% sole angle
            [soleAng_beforeFS,soleAng_midStance] = getSoleAngle(btkData,side{1,s},mFS,mFO);
            results_norm.soleAngle_midStance((subj-1)*2+s,1) = soleAng_midStance;
            results_norm.soleAngle_beforeFS((subj-1)*2+s,1) = soleAng_beforeFS;
            
            %% Varus/valgus (varus >0)
            DMT1 = filtered_markers(:,:,8);
            DMT5 = filtered_markers(:,:,9);
            [varusAng_beforeFS,varusAng_beforeFO,varusAng_midStance] = getVarusAngle(DMT1,DMT5,mFS,mFO);
            results_norm.varusAngle_midStance((subj-1)*2+s,1) = varusAng_midStance;
            results_norm.varusAngle_beforeFS((subj-1)*2+s,1) = varusAng_beforeFS;
            results_norm.varusAngle_beforeFO((subj-1)*2+s,1) = varusAng_beforeFO;

            %all data are reduced to 150 Hz
            f = 150;
            if btkGetPointFrequency(btkData) == 300
                n = round(btkGetPointFrameNumber(btkData)/2);
            else
                n = btkGetPointFrameNumber(btkData);
            end
            for iMk = 1:length(FootMarkersName)
                %% Zeni
                [FS_Zeni,FO_Zeni] = Zeni(filtered_markers(:,:,iMk),pelvicMk,gaitAxis);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Zeni,FO_Zeni);
                results_norm.FS_error_Zeni((subj-1)*2+s,iMk) = errorFS;
                results_norm.FO_error_Zeni((subj-1)*2+s,iMk) = errorFO;
                
                %% Ghoussayni
                [FS_Gh,FO_Gh] = Ghoussayni(filtered_markers(:,:,iMk),pelvicMk,gaitAxis,verticalAxis,n,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Gh,FO_Gh);
                results_norm.FS_error_Ghoussayni((subj-1)*2+s,iMk) = errorFS;
                results_norm.FO_error_Ghoussayni((subj-1)*2+s,iMk) = errorFO;

                %% Desailly
                [FS_Des,FO_Des] = Desailly(nonfiltered_markers(:,:,1),nonfiltered_markers(:,:,iMk),pelvicMk,gaitAxis,verticalAxis,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Des,FO_Des);
                results_norm.FS_error_Desailly((subj-1)*2+s,iMk) = errorFS;
                results_norm.FO_error_Desailly((subj-1)*2+s,iMk) = errorFO;
                
                %% Hsue
                [FS_Hsue,FO_Hsue] = Hsue(filtered_markers(:,:,iMk),pelvicMk,gaitAxis,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Hsue,FO_Hsue);
                results_norm.FS_error_Hsue((subj-1)*2+s,iMk) = errorFS;
                results_norm.FO_error_Hsue((subj-1)*2+s,iMk) = errorFO;
                
                %% Hreljac
                [FS_Hreljac,FO_Hreljac] = Hreljac(filtered_markers(:,:,iMk),pelvicMk,gaitAxis,verticalAxis,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Hreljac,FO_Hreljac);
                results_norm.FS_error_Hreljac((subj-1)*2+s,iMk) = errorFS;
                results_norm.FO_error_Hreljac((subj-1)*2+s,iMk) = errorFO;

            end % Markers
            
            btkDeleteAcquisition(btkData);
        end % side (left,right)
    end
end % subjects

results_norm.soleAng_midStance_mean = mean(results_norm.soleAngle_midStance);
results_norm.soleAng_midStance_std = std(results_norm.soleAngle_midStance);

results_norm.varusAng_midStance_mean = mean(results_norm.varusAngle_midStance);
results_norm.varusAng_midStance_std = std(results_norm.varusAngle_midStance);

save([exportFolder '\results_norm.mat'],'results_norm');
clear btkData c3dPath dataStr fpCell left right side subjects
clear nonfiltered_markers filtered_markers DMT1 DMT5 pelvicMk
clear f n s iMk subj
clear FO_Des FO_Gh FO_Hreljac FO_Hsue FO_Zeni mFO errorFO
clear FS_Des FS_Gh FS_Hreljac FS_Hsue FS_Zeni mFS errorFS
clear soleAng_beforeFS soleAng_midStance  
clear varusAng_beforeFO varusAng_beforeFS varusAng_midStance

% -------------------------------------------------------------------------
%% diplegic subjects
% -------------------------------------------------------------------------
subjectFolder = [dataFolder '\data_diparese'];

%% hold the description of the data
T = readtable([subjectFolder '\di_CP_sofamea.xlsx']);
left = T.left;
right = T.right;
subjects = T.Subject_Study;
clear T

results_patients.nameMarkers = FootMarkersName;

for subj= 1:size(subjects,1)
    dataStr = subjects{subj,1}; % subject name
    if ~isempty(dataStr)
        side = {'L' 'R'};
        for s = 1:length(side)
            results_patients.nameSubjects{(subj-1)*2+s,1} = [dataStr '_' side{1,s}];
            % informations of the side from excel sheet
            switch(side{1,s})
                case 'L'
                    infoSide = left{subj,1};
                case 'R'
                    infoSide = right{subj,1};
            end
            textSplit = regexp(infoSide,'Tr \d*| FP \d','match');
            trialCell = regexp(textSplit{1,1},'\d*','match');
            trial = str2num(trialCell{1,1});
            fpCell = regexp(textSplit{1,2},'\d*','match');
            
            %% path of the c3d
            if trial <= 9
                c3dPath = [subjectFolder '\' dataStr '_0' trialCell{1,1} '.c3d'];
            else
                c3dPath = [subjectFolder '\' dataStr '_' trialCell{1,1} '.c3d'];
            end

            clear textSplit trialCell trial infoSide
            
            %% Load C3D data
            btkData = btkReadAcquisition(c3dPath);
            
            %% load, rotate, filter markers
            [nonfiltered_markers,filtered_markers,pelvicMk] = getMarkers(btkData,side{1,s},FootMarkersName);
            
            %% Get gait events measured using forceplates
            [mFS,mFO] = getMeasuredGaitEvents(btkData,str2num(fpCell{1,1}),20);
            
            %% sole angle
            [soleAng_beforeFS,~] = getSoleAngle(btkData,side{1,s},mFS,mFO);
            results_patients.soleAngle_beforeFS((subj-1)*2+s,1) = soleAng_beforeFS;
            
            %% Varus/valgus (varus >0)
            DMT1 = filtered_markers(:,:,8);
            DMT5 = filtered_markers(:,:,9);
            [varusAng_beforeFS,varusAng_beforeFO,~] = getVarusAngle(DMT1,DMT5,mFS,mFO);
            results_patients.varusAngle_beforeFS((subj-1)*2+s,1) = varusAng_beforeFS;
            results_patients.varusAngle_beforeFO((subj-1)*2+s,1) = varusAng_beforeFO;

            %all data are reduced to 150 Hz
            f = 150;
            if btkGetPointFrequency(btkData) == 300
                n = round(btkGetPointFrameNumber(btkData)/2);
            else
                n = btkGetPointFrameNumber(btkData);
            end
            for iMk = 1:length(FootMarkersName)
                %% Zeni
                [FS_Zeni,FO_Zeni] = Zeni(filtered_markers(:,:,iMk),pelvicMk,gaitAxis);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Zeni,FO_Zeni);
                results_patients.FS_error_Zeni((subj-1)*2+s,iMk) = errorFS;
                results_patients.FO_error_Zeni((subj-1)*2+s,iMk) = errorFO;
                
                %% Ghoussayni
                [FS_Gh,FO_Gh] = Ghoussayni(filtered_markers(:,:,iMk),pelvicMk,gaitAxis,verticalAxis,n,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Gh,FO_Gh);
                results_patients.FS_error_Ghoussayni((subj-1)*2+s,iMk) = errorFS;
                results_patients.FO_error_Ghoussayni((subj-1)*2+s,iMk) = errorFO;
                
                %% Desailly
                [FS_Des,FO_Des] = Desailly(nonfiltered_markers(:,:,1),nonfiltered_markers(:,:,iMk),pelvicMk,gaitAxis,verticalAxis,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Des,FO_Des);
                results_patients.FS_error_Desailly((subj-1)*2+s,iMk) = errorFS;
                results_patients.FO_error_Desailly((subj-1)*2+s,iMk) = errorFO;
                
                %% Hsue
                [FS_Hsue,FO_Hsue] = Hsue(filtered_markers(:,:,iMk),pelvicMk,gaitAxis,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Hsue,FO_Hsue);
                results_patients.FS_error_Hsue((subj-1)*2+s,iMk) = errorFS;
                results_patients.FO_error_Hsue((subj-1)*2+s,iMk) = errorFO;
                
                %% Hreljac
                [FS_Hreljac,FO_Hreljac] = Hreljac(filtered_markers(:,:,iMk),pelvicMk,gaitAxis,verticalAxis,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Hreljac,FO_Hreljac);
                results_patients.FS_error_Hreljac((subj-1)*2+s,iMk) = errorFS;
                results_patients.FO_error_Hreljac((subj-1)*2+s,iMk) = errorFO;

            end % Markers
            
            btkDeleteAcquisition(btkData);
        end % side (left,right)
    end
end % subjects
dipSubj_number = length(results_patients.nameSubjects);
clear btkData c3dPath dataStr fpCell left right side subjects
clear nonfiltered_markers filtered_markers DMT1 DMT5 pelvicMk
clear f n s iMk subj
clear FO_Des FO_Gh FO_Hreljac FO_Hsue FO_Zeni mFO errorFO
clear FS_Des FS_Gh FS_Hreljac FS_Hsue FS_Zeni mFS errorFS
clear soleAng_beforeFS varusAng_beforeFO varusAng_beforeFS

% -------------------------------------------------------------------------
%% hemiplegic subjects
% -------------------------------------------------------------------------
subjectFolder = [dataFolder '\data_hemi'];

%% hold the description of the data
T = readtable([subjectFolder '\hemi_CP_sofamea.xlsx']);
left = T.left;
right = T.right;
affectedSide = T.LesionSide;
subjects = T.Subject_Study;
clear T

%% subjects
for subj= 1:size(subjects,1)
    dataStr = subjects{subj,1}; % subject name
    switch(affectedSide{subj,1})
        case 'Left'
            infoSide = left{subj,1};
            textSplit_aff = regexp(infoSide,'Tr \d*| FP \d','match');
            trialCell = regexp(textSplit_aff{1,1},'\d*','match');
            trial_aff = str2num(trialCell{1,1});

            infoSide = right{subj,1};
            textSplit_unaff = regexp(infoSide,'Tr \d*| FP \d','match');
            trialCell = regexp(textSplit_unaff{1,1},'\d*','match');
            trial_unaff = str2num(trialCell{1,1});
        case 'Right'
            infoSide = right{subj,1};
            textSplit_aff = regexp(infoSide,'Tr \d*| FP \d','match');
            trialCell = regexp(textSplit_aff{1,1},'\d*','match');
            trial_aff = str2num(trialCell{1,1});

            infoSide = left{subj,1};
            textSplit_unaff = regexp(infoSide,'Tr \d*| FP \d','match');
            trialCell = regexp(textSplit_unaff{1,1},'\d*','match');
            trial_unaff = str2num(trialCell{1,1});
    end
    if ~isempty(dataStr)
        hemi = {'affected'};% 'unaffected'};
        for h = 1:length(hemi)
            % informations of the side
            switch(hemi{1,h})
                case 'affected'
                    switch(affectedSide{subj,1})
                        case 'Left'
                            side = 'L';
                        case 'Right'
                            side = 'R';
                    end
                case 'unaffected'
                    switch(affectedSide{subj,1})
                        case 'Left'
                            side = 'R';
                        case 'Right'
                            side = 'L';
                    end
            end

            % path of the c3d
            switch(hemi{1,h})
                case 'affected'
                    results_patients.nameSubjects{dipSubj_number+1*(subj-1)+h,1} = [dataStr '_affected'];
                    if trial_aff == trial_unaff
                        c3dPath = [subjectFolder '\' dataStr '.c3d'];
                    else
                        c3dPath = [subjectFolder '\' dataStr '_affected.c3d'];
                    end
                    fpCell = regexp(textSplit_aff{1,2},'\d*','match');
                case 'unaffected'
                    results_patients.nameSubjects{dipSubj_number+1*(subj-1)+h,1} = [dataStr '_unaffected'];
                    if trial_aff == trial_unaff
                        c3dPath = [subjectFolder '\' dataStr '.c3d'];
                    else
                        c3dPath = [subjectFolder '\' dataStr '_unaffected.c3d'];
                    end
                    fpCell = regexp(textSplit_unaff{1,2},'\d*','match');
            end

            %% Load C3D data
            btkData = btkReadAcquisition(c3dPath);
            
            %% load, rotate, filter markers
            [nonfiltered_markers,filtered_markers,pelvicMk] = getMarkers(btkData,side,FootMarkersName);
            
            %% Get gait events measured using forceplates
            [mFS,mFO] = getMeasuredGaitEvents(btkData,str2num(fpCell{1,1}),20);
            
            %% sole angle
            [soleAng_beforeFS,~] = getSoleAngle(btkData,side,mFS,mFO);
            results_patients.soleAngle_beforeFS(dipSubj_number+1*(subj-1)+h,1) = soleAng_beforeFS;
            
            %% Varus/valgus (varus >0)
            DMT1 = filtered_markers(:,:,8);
            DMT5 = filtered_markers(:,:,9);
            [varusAng_beforeFS,varusAng_beforeFO,~] = getVarusAngle(DMT1,DMT5,mFS,mFO);
            results_patients.varusAngle_beforeFS(dipSubj_number+1*(subj-1)+h,1) = varusAng_beforeFS;
            results_patients.varusAngle_beforeFO(dipSubj_number+1*(subj-1)+h,1) = varusAng_beforeFO;

            %all data are reduced to 150 Hz
            f = 150;
            if btkGetPointFrequency(btkData) == 300
                n = round(btkGetPointFrameNumber(btkData)/2);
            else
                n = btkGetPointFrameNumber(btkData);
            end
            for iMk = 1:length(FootMarkersName)
                %% Zeni
                [FS_Zeni,FO_Zeni] = Zeni(filtered_markers(:,:,iMk),pelvicMk,gaitAxis);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Zeni,FO_Zeni);
                results_patients.FS_error_Zeni(dipSubj_number+1*(subj-1)+h,iMk) = errorFS;
                results_patients.FO_error_Zeni(dipSubj_number+1*(subj-1)+h,iMk) = errorFO;
                
                %% Ghoussayni
                [FS_Gh,FO_Gh] = Ghoussayni(filtered_markers(:,:,iMk),pelvicMk,gaitAxis,verticalAxis,n,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Gh,FO_Gh);
                results_patients.FS_error_Ghoussayni(dipSubj_number+1*(subj-1)+h,iMk) = errorFS;
                results_patients.FO_error_Ghoussayni(dipSubj_number+1*(subj-1)+h,iMk) = errorFO;

                %% Desailly
                [FS_Des,FO_Des] = Desailly(nonfiltered_markers(:,:,1),nonfiltered_markers(:,:,iMk),pelvicMk,gaitAxis,verticalAxis,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Des,FO_Des);
                results_patients.FS_error_Desailly(dipSubj_number+1*(subj-1)+h,iMk) = errorFS;
                results_patients.FO_error_Desailly(dipSubj_number+1*(subj-1)+h,iMk) = errorFO;
                
                %% Hsue
                [FS_Hsue,FO_Hsue] = Hsue(filtered_markers(:,:,iMk),pelvicMk,gaitAxis,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Hsue,FO_Hsue);
                results_patients.FS_error_Hsue(dipSubj_number+1*(subj-1)+h,iMk) = errorFS;
                results_patients.FO_error_Hsue(dipSubj_number+1*(subj-1)+h,iMk) = errorFO;
                
                %% Hreljac
                [FS_Hreljac,FO_Hreljac] = Hreljac(filtered_markers(:,:,iMk),pelvicMk,gaitAxis,verticalAxis,f);
                
                [errorFS,errorFO] = getError(mFS,mFO,FS_Hreljac,FO_Hreljac);
                results_patients.FS_error_Hreljac(dipSubj_number+1*(subj-1)+h,iMk) = errorFS;
                results_patients.FO_error_Hreljac(dipSubj_number+1*(subj-1)+h,iMk) = errorFO;

            end % Markers
            
            btkDeleteAcquisition(btkData);
        end % side (left,right)
    end
end % subjects

save([exportFolder '\results_patients.mat'],'results_patients');