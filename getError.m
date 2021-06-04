% function to calculate the error between the measured events and the
% estimated events for the first gait cycle after the general event defined
% in the c3d
% Input:
% - mFS,mFO = measured foot strikes and foot offs (in frames)
% - eFS,eFO = estimated foot strikes and foot offs (vector, in frames)
%
% Output:
% values in milli-seconds by 150Hz
% - errorFS = error for the foot strike between estimated and measured
% values
% - errorFO = error for the foot off between estimated and measured values

function [errorFS,errorFO] = getError(mFS,mFO,eFS,eFO)

    [~,min_index] = min(abs(eFS - mFS));
    if abs(eFS(min_index)-mFS) >= 50 %mFS +/- window 30 frames about FS from Zeni (which error could be until 20: experiently)
        errorFS = NaN;
    else
        errorFS = (eFS(min_index)-mFS)*1000/150;
    end

    [~,min_index] = min(abs(eFO - mFO));
    if abs(eFO(min_index)-mFO) >= 50 %mFO +/- window 30 frames about FO from Zeni (which error could be until 20: experiently)
        errorFO = NaN;
    else
        errorFO = (eFO(min_index)-mFO)*1000/150;
    end