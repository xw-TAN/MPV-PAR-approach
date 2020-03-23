function [ Wrms ] = GetWindowsRMS( Input, Size )
%GETWINDOWSRMS Divides the divergence rate vector into subwindows and 
%compute each subwindow's root-mean-square value
%
% *input
%   - Input         # Divergence rate vector
%   - Size          # Number of subwindows
%
% *output
%   - Wrms          # Vector contains RMS values of each subwindow
% -------------------------------------------------------------------------

% divide 'Input' into subwindows with size 'Size'
StepLength = fix(length(Input)/Size);
Wrms = zeros(Size,1);

% compute RMS of each subwindow
for i=1:1:Size-1
    Wrms(i) = rms( Input((i-1) * StepLength + 1 : i * StepLength) );
end

% compute RMS of the remaining data
Wrms(Size) = rms( Input((Size-1) * StepLength + 1 : length(Input)) );

end

