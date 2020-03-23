% Script used to generate exemplar phase curves and associated data
%
% *input
%   - levelWalk
%   - upStairs
%   - downStairs
%   Input struct contains:
%        --- *****/     # Types of activity
%        	--- time/	# Time of a complete stride (begin with zero)
%        	--- data/	# Global thigh angle corresponds to that stride
%   NOTE: If creating exemplar dataset for MPV method, the strides data
%   should be divided with specific initial point (minimal global thigh
%   angle in here).
%
% *output
%   - PWalkDataset
%   - PUpDataset
%   - PDownDataset
%   Output struct contains:
%        --- *****/         # Types of activity
%           --- *BaseAngle/	# Initial angle of exemplar phase curves
%           --- pValue/     # Normalized progession value of points
%           --- PhaseAngle/	# Angle of points with respect to initial line
%           --- pPoint/     # X and Y coordinates of each point at curves
%           --- *Origin/	# Coordinates of the centroid
%           --- *Range/     # Value range of X and Y
% -------------------------------------------------------------------------

clear;
close all;
clc;

% define type of method 
method = 'MPVV';
% method = 'PV';

% stride data used to create exemplar phase curves and associated data.
% the example data are seven-subject-averaged global thigh angle (excl. S4).
load('Example_Cross_S4.mat')

TimeWalk    = levelWalk.time;
Walk        = levelWalk.data;
TimeUp      = upStairs.time;
Up          = upStairs.data;
TimeDown    = downStairs.time;
Down        = downStairs.data;

% -------------------------------------------------------------------------
% time normalization
if ~strcmp(method, 'PV')
    timeScale = 2;
    TimeWalk = timeScale / max(TimeWalk) .* TimeWalk;
    TimeDown = timeScale / max(TimeDown) .* TimeDown;
    TimeUp   = timeScale / max(TimeUp)   .* TimeUp;
end

% -------------------------------------------------------------------------
%% levelWalk
% search the point with value approximate to the value of initial point
% searching from the location of fix(length(Walk)/2) to end
Subtract = abs(Walk(fix(length(Walk)/2):length(Walk)) - Walk(1));
% get the location
loc = fix(length(Walk)/2) + find(Subtract == min(Subtract)) - 1;
% cut out into a self-consistent stride in order to form a closed curve
Walk = Walk(1:loc);
TimeWalk = TimeWalk(1:loc);

% compute the coordinate Y
yWalk = zeros(size(TimeWalk));
for i=2:length(TimeWalk)
    yWalk(i)=trapz(TimeWalk(1:i), Walk(1:i) - mean(Walk));
end

% add a point at the end to form a closed-curve
len = length(TimeWalk);
yWalk(len+1) = yWalk(1);
Walk(len+1) = Walk(1);
TimeWalk(len+1) = TimeWalk(len) + TimeWalk(2);  % time begins with zero

% get coordinates of the centroid
xbWalk = mean(Walk);
ybWalk = mean(yWalk);

% plot the exemplar phase curve of level walking
figure('name', 'Exemplar Phase Curves'); hold on
% axis equal
plot(Walk,yWalk, 'r', 'linewidth', 6);
hl(1) = plot(xbWalk, ybWalk, 'r.', 'markerSize', 30);
grid;

% -------------------------------------------------------------------------
%% upStairs
Subtract = abs(Up(fix(length(Up)/2):length(Up)) - Up(1));
loc = fix(length(Up)/2) + find(Subtract == min(Subtract)) - 1;
Up = Up(1:loc);
TimeUp = TimeUp(1:loc);

% Y coordinate for exemplar upStair phase curve
yUp = zeros(size(TimeUp));
for i=2:length(TimeUp)
    yUp(i)=trapz(TimeUp(1:i), Up(1:i) - mean(Up));
end

% form a closed phase curve
len = length(TimeUp);
yUp(len+1) = yUp(1);
Up(len+1) = Up(1);
TimeUp(len+1)=TimeUp(len) + TimeUp(2);

% centroid coordinates
xbUp = mean(Up);
ybUp = mean(yUp);

% plot the exemplar phase curve for upStairs
plot(Up,yUp,'g','linewidth',6);
hl(2) = plot(xbUp,ybUp,'g.','markersize',30);

% -------------------------------------------------------------------------
%% downStairs
Subtract = abs(Down(fix(length(Down)/2):length(Down)) - Down(1));
loc = fix(length(Down)/2) + find(Subtract == min(Subtract)) - 1;
Down = Down(1:loc);
TimeDown = TimeDown(1:loc);

% compute the coordinate Y
yDown = zeros(size(TimeDown));
for i=2:length(TimeDown)
    yDown(i)=trapz(TimeDown(1:i), Down(1:i) - mean(Down));
end

% form a closed phase curve
len = length(TimeDown);
yDown(len+1) = yDown(1);
Down(len+1) = Down(1);
TimeDown(len+1)=TimeDown(len) + TimeDown(2);

% centroid coordinates
xbDown = mean(Down);
ybDown = mean(yDown);

% plot the exemplar phase curve for downStairs
plot(Down,yDown, 'b', 'linewidth', 6);
hl(3) = plot(xbDown,ybDown, 'b.', 'markersize', 30);

% complete the figure for phase curves
ylabel('y (deg﹞s)','FontWeight','bold','Fontsize',25);
xlabel('x (deg)','FontWeight','bold','Fontsize',25);
title('Phase Space','FontWeight','bold','Fontsize',20);
axis([-15, 50, -8, 13]);
set(gca,'FontSize',25,'FontWeight','bold','Fontsize',20, ...
    'box', 'on', 'position', [.05 .2 .3 .6]);
set(get(gca,'YLabel'),'Fontsize',25,'FontWeight','bold');
set(get(gca,'XLabel'),'Fontsize',25,'FontWeight','bold');
set(hl,'handlevisibility','off');
legend('Walk', 'Up', 'Down',...
    'Location','NorthOutside','Orientation','horizontal');

% -------------------------------------------------------------------------
%% plot phase curves at activity-specific coordinate frames
% new coordinate frame for levelWalk
xWalkNew = Walk - xbWalk;
yWalkNew = yWalk - ybWalk;

figure('Name', 'NewCoordinateWalk'); hold on;
% axis equal
ylabel('y (deg﹞s)','FontWeight','bold','Fontsize',25);
xlabel('x (deg)','FontWeight','bold','Fontsize',25);
title('Phase Space','FontWeight','bold','Fontsize',20);
set(gca,'FontSize',25,'FontWeight','bold','Fontsize',20,...
    'box', 'on', 'position', [.05 .2 .3 .6]);
set(get(gca,'YLabel'),'Fontsize',25,'FontWeight','bold');
set(get(gca,'XLabel'),'Fontsize',25,'FontWeight','bold');
axis([-50,60,-50,40]);
grid

% plot web with interval scale of 0.3
for i=0:0.3:10
    plot(i.*xWalkNew, i.*yWalkNew, 'k', 'linewidth', 0.5)
end
plot(xWalkNew, yWalkNew, 'r', 'linewidth', 6);

% -------------------------------------------------------------------------
% new coordinate frame for upStairs
xUpNew = Up - xbUp;
yUpNew = yUp - ybUp;

figure('Name', 'NewCoordinateUp'); hold on;
% axis equal
ylabel('y (deg﹞s)','FontWeight','bold','Fontsize',25);
xlabel('x (deg)','FontWeight','bold','Fontsize',25);
title('Phase Space','FontWeight','bold','Fontsize',20);
set(gca,'FontSize',25,'FontWeight','bold','Fontsize',20,...
    'box', 'on', 'position', [.05 .2 .3 .6]);
set(get(gca,'YLabel'),'Fontsize',25,'FontWeight','bold');
set(get(gca,'XLabel'),'Fontsize',25,'FontWeight','bold');
axis([-80,80,-70,60]);
grid

% plot web with interval scale of 0.3
for i=0:0.3:10
    plot(i.*xUpNew, i.*yUpNew, 'k','linewidth', 0.5)
end
plot(xUpNew, yUpNew, 'g', 'linewidth', 6);

% -------------------------------------------------------------------------
% new coordinate frame for downStairs
xDownNew = Down - xbDown;
yDownNew = yDown - ybDown;

figure('Name', 'NewCoordinateDown'); hold on;
% axis equal
ylabel('y (deg﹞s)','FontWeight','bold','Fontsize',25);
xlabel('x (deg)','FontWeight','bold','Fontsize',25);
title('Phase Space','FontWeight','bold','Fontsize',20);
set(gca,'FontSize',25,'FontWeight','bold','Fontsize',20,...
    'box', 'on', 'position', [.05 .2 .3 .6]);
set(get(gca,'YLabel'),'Fontsize',25,'FontWeight','bold');
set(get(gca,'XLabel'),'Fontsize',25,'FontWeight','bold');
axis([-20,40,-25,25]);
grid

% plot web with interval scale of 0.3
for i=0:0.3:10
    plot(i.*xDownNew, i.*yDownNew, 'k','linewidth', 0.5)
end
plot(xDownNew, yDownNew, 'b', 'linewidth', 6);

% -------------------------------------------------------------------------
% extract information from phase curves
%% levelWalk
% herein using normalized time to substitute normalized progression
timeScale = 1;
PWalkDataset.pValue = timeScale / max(TimeWalk) .* TimeWalk;

% base angle used to computed relative angle of points
PWalkDataset.WalkBaseAngle = atan2(yWalkNew(1),xWalkNew(1));

% X and Y coordinates and relative angle of points located at the curve
PWalkDataset.pPoint(1).x = Walk(1);
PWalkDataset.pPoint(1).y = yWalk(1);
% phase angle of each point at the exemplar phase curve, which will be
% used in searching adjacent points to the POINT to be parameterized.
PWalkDataset.PhaseAngle = zeros(size(TimeWalk));
for i=2:1:length(TimeWalk)
    Angle = atan2(yWalkNew(i),xWalkNew(i)) - PWalkDataset.WalkBaseAngle;
    if(Angle <= 0)
        PWalkDataset.PhaseAngle(i) = Angle + 2 * pi;
    else
        PWalkDataset.PhaseAngle(i) = Angle;
    end
    % store coordinates X and Y which will be used to compute intersection
    % point and magnitude
    PWalkDataset.pPoint(i).x = Walk(i);
    PWalkDataset.pPoint(i).y = yWalk(i);
end

% coordinates of centroid
PWalkDataset.WalkOrigin.x = xbWalk;
PWalkDataset.WalkOrigin.y = ybWalk;

% value range of X and Y coodinates (used in MPV method to normalize
% coordinates and penalty the X
PWalkDataset.WalkRange.x = max(Walk) - min(Walk);
PWalkDataset.WalkRange.y = max(yWalk) - min(yWalk);

% -------------------------------------------------------------------------
%% upStairs
PUpDataset.pValue = timeScale/max(TimeUp).*TimeUp;
PUpDataset.UpBaseAngle = atan2(yUpNew(1),xUpNew(1));

% X and Y coordinates and relative angle
PUpDataset.pPoint(1).x = Up(1);
PUpDataset.pPoint(1).y = yUp(1);
PUpDataset.PhaseAngle = zeros(size(TimeUp));
for i=2:1:length(TimeUp)
    Angle = atan2(yUpNew(i),xUpNew(i)) - PUpDataset.UpBaseAngle;
    if(Angle <= 0)
        PUpDataset.PhaseAngle(i) = Angle + 2 * pi;
    else
        PUpDataset.PhaseAngle(i) = Angle;
    end
    PUpDataset.pPoint(i).x = Up(i);
    PUpDataset.pPoint(i).y = yUp(i);
end

% centroid
PUpDataset.UpOrigin.x = xbUp;
PUpDataset.UpOrigin.y = ybUp;

% value range
PUpDataset.UpRange.x = max(Up) - min(Up);
PUpDataset.UpRange.y = max(yUp) - min(yUp);

% -------------------------------------------------------------------------
%% downStairs
PDownDataset.pValue = timeScale/max(TimeDown).*TimeDown;
PDownDataset.DownBaseAngle = atan2(yDownNew(1),xDownNew(1));

% X and Y coordinates and relative angle
PDownDataset.pPoint(1).x = Down(1);
PDownDataset.pPoint(1).y = yDown(1);
PDownDataset.PhaseAngle = zeros(size(TimeDown));
for i=2:1:length(TimeDown)
    Angle = atan2(yDownNew(i),xDownNew(i)) - PDownDataset.DownBaseAngle;
    if(Angle <= 0)
        PDownDataset.PhaseAngle(i) = Angle + 2 * pi;
    else
        PDownDataset.PhaseAngle(i) = Angle;
    end
    PDownDataset.pPoint(i).x = Down(i);
    PDownDataset.pPoint(i).y = yDown(i);
end

% centroid
PDownDataset.DownOrigin.x = xbDown;
PDownDataset.DownOrigin.y = ybDown;

% value range
PDownDataset.DownRange.x = max(Down) - min(Down);
PDownDataset.DownRange.y = max(yDown) - min(yDown);

% save exemplar data as .mat file
fName = 'ExampleResult_';
save([fName, method], 'PWalkDataset', 'PUpDataset', 'PDownDataset');

% clear temporary variables
clearvars -EXCEPT PDownDataset PUpDataset PWalkDataset;
