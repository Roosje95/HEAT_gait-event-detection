load('C:\Users\FreslierM\Desktop\output\results_norm.mat')
load('C:\Users\FreslierM\Desktop\output\results_patients.mat')

% -------------------------------------------------------------------------
%% Sole angle
% -------------------------------------------------------------------------
%% Sole angle midstance, norm
flatfoot_solAng_mean = results_norm.soleAng_midStance_mean; % =~0
flatfoot_solAng_SD = results_norm.soleAng_midStance_std; % =~1

% groups
% 1st group (dorsiflexion): > mean + 2SD =~ 1.5° (4SD = 4.4°)
% 2nd group (flat foot): mean +/- 2SD
% 3rd group (mild equinus): < mean - 2SD =~ -2°
% 4th group (high equinus): < mean - 10SD =~ -10° plantarflexion (exact
% -9.75°)
for i=1:length(results_norm.soleAngle_beforeFS)
    if results_norm.soleAngle_beforeFS(i) > flatfoot_solAng_mean+2*flatfoot_solAng_SD
        results_norm.soleAngle_beforeFS_grp(i,1) = 1;
    elseif results_norm.soleAngle_beforeFS(i) >= flatfoot_solAng_mean-2*flatfoot_solAng_SD
        results_norm.soleAngle_beforeFS_grp(i,1) = 2;
    elseif results_norm.soleAngle_beforeFS(i) >= flatfoot_solAng_mean-10*flatfoot_solAng_SD
        results_norm.soleAngle_beforeFS_grp(i,1) = 3;
    else
        results_norm.soleAngle_beforeFS_grp(i,1) = 4;
    end
end

%% sole angle before FS, CP patients
% groups
% 1st group (dorsiflexion): > mean + 2SD =~ 1.5° (4SD = 4.4°)
% 2nd group (flat foot): mean +/- 2SD
% 3rd group (mild equinus): < mean - 2SD =~ -2°
% 4th group (high equinus): < mean - 10SD =~ -10° plantarflexion (exact
% -9.75°)
for i=1:length(results_patients.soleAngle_beforeFS)
    if results_patients.soleAngle_beforeFS(i) > flatfoot_solAng_mean+2*flatfoot_solAng_SD
        results_patients.soleAngle_beforeFS_grp(i,1) = 1;
    elseif results_patients.soleAngle_beforeFS(i) >= flatfoot_solAng_mean-2*flatfoot_solAng_SD
        results_patients.soleAngle_beforeFS_grp(i,1) = 2;
    elseif results_patients.soleAngle_beforeFS(i) >= flatfoot_solAng_mean-10*flatfoot_solAng_SD
        results_patients.soleAngle_beforeFS_grp(i,1) = 3;
    else
        results_patients.soleAngle_beforeFS_grp(i,1) = 4;
    end
end

% -------------------------------------------------------------------------
%% Varus angle
% -------------------------------------------------------------------------
%% Varus angle midstance, norm
flatfoot_varAng_mean = results_norm.varusAng_midStance_mean; % =~0
flatfoot_varAng_SD = results_norm.varusAng_midStance_std; % =~1

%% varus angle before FO, norm
% 1st group (varus): > mean + 2SD =~ 12°
% 2rd group (flat foot): mean +/- 2SD
% 3th group (mild valgus): < mean - 2SD =~ 0.6°
% 4th group (high valgus): < mean - 4SD =~ -5°
for i=1:length(results_norm.varusAngle_beforeFO)
    if results_norm.varusAngle_beforeFO(i) > flatfoot_varAng_mean+2*flatfoot_varAng_SD
        results_norm.varusAngle_beforeFO_grp(i,1) = 1;
    elseif results_norm.varusAngle_beforeFO(i) >= flatfoot_varAng_mean-2*flatfoot_varAng_SD
        results_norm.varusAngle_beforeFO_grp(i,1) = 2;
    elseif results_norm.varusAngle_beforeFO(i) >= flatfoot_varAng_mean-4*flatfoot_varAng_SD
        results_norm.varusAngle_beforeFO_grp(i,1) = 3;
    else
        results_norm.varusAngle_beforeFO_grp(i,1) = 4;
    end
end

%% varus angle before FO, CP patients
% 1st group (varus): > mean + 2SD =~ 12°
% 2rd group (flat foot): mean +/- 2SD
% 3th group (mild valgus): < mean - 2SD =~ 0.6°
% 4th group (high valgus): < mean - 4SD =~ -5°
for i=1:length(results_patients.varusAngle_beforeFO)
    if results_patients.varusAngle_beforeFO(i) > flatfoot_varAng_mean+2*flatfoot_varAng_SD
        results_patients.varusAngle_beforeFO_grp(i,1) = 1;
    elseif results_patients.varusAngle_beforeFO(i) >= flatfoot_varAng_mean-2*flatfoot_varAng_SD
        results_patients.varusAngle_beforeFO_grp(i,1) = 2;
    elseif results_patients.varusAngle_beforeFO(i) >= flatfoot_varAng_mean-4*flatfoot_varAng_SD
        results_patients.varusAngle_beforeFO_grp(i,1) = 3;
    else
        results_patients.varusAngle_beforeFO_grp(i,1) = 4;
    end
end

save('C:\Users\FreslierM\Desktop\output\results_norm.mat','results_norm');
save('C:\Users\FreslierM\Desktop\output\results_patients.mat','results_patients');