function [Heatmap] = OrderHeatmap_Marie(error)
%function to orders the error values to location on foot for heatmap
%Marker list:  
%1.HEE 
%2.TPR
%3.SITA
%4.ANK
%5.PMT1
%6.PMT5
%7.CUN
%8.DMT1
%9.DMT5
%10.TOE
%11.HLX

%% Top view
Heatmap.top = zeros(7,3); %7x3 matrix

Heatmap.top(1,1,1) = error(1,11);% hallux marker
Heatmap.top(1,2,:) = NaN;
Heatmap.top(1,3,:) = NaN;

Heatmap.top(2,1,:) = NaN;
Heatmap.top(2,2,:) = NaN;
Heatmap.top(2,3,:) = NaN;

Heatmap.top(3,1,1) = error(1,8); % mean abs error dmt1  marker
Heatmap.top(3,2,1) = error(1,10);% mean abs error toe marker
Heatmap.top(3,3,1) = error(1,9);% mean abs error dmt5 marker

Heatmap.top(4,1,1) = error(1,5); % mean abs error pmt1 marker
Heatmap.top(4,2,1) = error(1,7); % mean abs error cun marker
Heatmap.top(4,3,1) = error(1,6); %mean abs error pmt5 marker

Heatmap.top(5,1,:) = NaN;
Heatmap.top(5,2,1) = error(1,3); %mean abs error sita
Heatmap.top(5,3,1) = NaN;

Heatmap.top(6,1,:) = NaN;
Heatmap.top(6,2,1) = NaN; %mean abs error ankle
Heatmap.top(6,3,1) = error(1,4); %mean abs error tpr

Heatmap.top(7,1,:) = NaN;
Heatmap.top(7,2,1) = error(1,1); %mean abs error heel marker
Heatmap.top(7,3,1) = error(1,2); %mean abs error tpr

%% Side view
Heatmap.side = zeros(4,7); %4x7 matrix

Heatmap.side(1,1,:) = NaN;
Heatmap.side(2,1,:) = NaN;
Heatmap.side(3,1,1) = error(1,1); % Heel Marker
Heatmap.side(4,1,1) = error(1,1); % Heel Marker

Heatmap.side(1,2,1) = error(1,4);%mean abs error ankle marker
Heatmap.side(2,2,1) = error(1,4);%mean abs error ankle marker
Heatmap.side(3,2,1) = error(1,2);%mean abs error tpr
Heatmap.side(4,2,:) = NaN;

Heatmap.side(1,3,:) = NaN;
Heatmap.side(2,3,1) = error(1,3); %mean abs error sita
Heatmap.side(3,3,1) = NaN;%average of mean errors of tpr, sita and pmt5
Heatmap.side(4,3,:) = NaN;

Heatmap.side(1,4,:) = NaN;
Heatmap.side(2,4,1) = error(1,7);% mean abs error cun marker
Heatmap.side(3,4,1) = NaN; %average of mean errors of pmt5 and cun
Heatmap.side(4,4,1) = error(1,6);%mean abs error pmt5 marker

Heatmap.side(1,5,:) = NaN;
Heatmap.side(2,5,:) = NaN;
Heatmap.side(3,5,1) = error(1,10); %mean abs error toe marker
Heatmap.side(4,5,1) = error(1,9);%mean abs error dmt5 marker

Heatmap.side(1,6,:) = NaN;
Heatmap.side(2,6,:) = NaN;
Heatmap.side(3,6,:) = NaN;
Heatmap.side(4,6,:) = NaN;

Heatmap.side(1,7,:) = NaN;
Heatmap.side(2,7,:) = NaN;
Heatmap.side(3,7,1) = error(1,11);%mean abs error hallux marker
Heatmap.side(4,7,1) = error(1,11);%mean abs error hallux marker

end

