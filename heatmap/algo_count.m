% function to count the number of subjects in each group of errors
% Input:
% - errorTab: maxtrix of error values, subjects in rows, markers in columns
% Output:
% - grp: vector of number of subjects in each group of errors:
%       1: error < -6 (-40)
%       2: -6 <= error < -3 (-40  -20)
%       3: -3 <= error <= 3 (-20  20)
%       4: 3 < error <= 6 (20  40)
%       5: error > 6 (40)

function grp = algo_count(errorTab)
    grp = zeros(5,size(errorTab,2)); % 5 categories, 11 markers
    for mq = 1:size(errorTab,2)
        for i=1:size(errorTab,1)
            if errorTab(i,mq) > 40%6
                grp(5,mq) = grp(5,mq) + 1;
            elseif errorTab(i,mq) > 20%3
                grp(4,mq) = grp(4,mq) + 1;
            elseif errorTab(i,mq) >= -20%-3
                grp(3,mq) = grp(3,mq) + 1;
            elseif errorTab(i,mq) >= -40%-6
                grp(2,mq) = grp(2,mq) + 1;
            else
                grp(1,mq) = grp(1,mq) + 1;
            end
        end
    end
end