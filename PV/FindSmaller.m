function [ Smaller ] = FindSmaller( par1, par1Name, par2, par2Name )

% if RMS value of 'par1Name' is less than  'par2Name' activity
if sum(par1 < par2) > sum(par1 > par2)
    Smaller.par = par1;
    Smaller.name = par1Name;
%     Smaller.confidence = (sum(par1 < par2) - sum(par1 > par2))/length(par1);
else
    Smaller.par = par2;
    Smaller.name = par2Name;
%     Smaller.confidence = (sum(par1 > par2) - sum(par1 < par2))/length(par1);
end

end

