function [ dValue ] = Getdt( Time, Value, ActCoordinate, path)
%GETDT Gets the divergence rate vector of one stride with respect to
%exemplar phase curves, or says, the divergence rate vector is computed at
%exemplar coordinate frames.
%
% NOTE:
% 1. unrecognized activity/phase curve denotes the activity waited to be
% recognized, or the phase curve plotted with stride data of that activity.
% 2. exemplar/template data/phase curve denotes the data extracted from
% specific activities, or denotes phaes curve of that specific activities.
%
% *input
%   - Time              # Stride time
%   - Value             # Global thigh angle of that stride
%   - ActCoordinate     # Activity type used as the template activity
%   - path              # Path contained the template data
%
% *output
%   - dValue            # Divergence rate vector contained the divergence
%   # rates of points located at the unrecognized phase curve
% -------------------------------------------------------------------------

% load the template data
load(path);

% form a closed phase curve
StartSubtract = abs(Value(fix(length(Value)/2):length(Value)) - Value(1));
loc = fix(length(Value)/2) + find(StartSubtract == min(StartSubtract)) - 1;
Value = Value(1:loc);
Time = Time(1:loc);

% X and Y coordinates of the unrecognized activity
y = zeros(size(Time));
for i=2:length(Time)
    y(i)=trapz(Time(1:i),Value(1:i)-mean(Value));
end

% used to store progression and magnitude
pValue = zeros(size(Value));
mValue = zeros(size(Value));

% get the exemplar data
switch ActCoordinate
    case 'LevelWalk'
        Origin =      PWalkDataset.WalkOrigin;
        BaseAngle =   PWalkDataset.WalkBaseAngle;
        PDataset =    PWalkDataset;
    case 'UpStairs'
        Origin =      PUpDataset.UpOrigin;
        BaseAngle =   PUpDataset.UpBaseAngle;
        PDataset =    PUpDataset;
    case 'DownStairs'
        Origin =      PDownDataset.DownOrigin;
        BaseAngle =   PDownDataset.DownBaseAngle;
        PDataset =    PDownDataset;
end

% compute the magnitude
for i=1:1:length(Value)
    Point.x = Value(i);
    Point.y = y(i);
    % get the adjacent points (K1 and K2 in paper)
    [ pValue(i),LastPoint,NextPoint ] = Getp( Origin, Point, BaseAngle, PDataset);
    % get the magnitue of the current point
    [ mValue(i) ] = Getm( Origin, LastPoint, NextPoint, Point);
end

% compute the divergence rate  (derivative to the progression)
dValue = zeros(size(mValue));
for i=1:1:length(mValue)-1
    dValue(i) = (mValue(i+1)-mValue(i)) / (pValue(i+1)-pValue(i));
end

end

