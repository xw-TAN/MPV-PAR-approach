function [ Smaller ] = FindSmaller( par1, par1Name, par2, par2Name )

% if 'par1Name' owns more smaller subwindows
if sum(par1 < par2) > sum(par1 > par2)
    Smaller.par = par1;
    Smaller.name = par1Name;
    % additional defined variable 'confidence'
    Smaller.confidence = (sum(par1 < par2) - sum(par1 > par2))/length(par1);
else
    Smaller.par = par2;
    Smaller.name = par2Name;
    Smaller.confidence = (sum(par1 > par2) - sum(par1 < par2))/length(par1);
end

end

