% Script used to implement Modified Phase-Variable-Based ( MPV) Human
% Physical Activity Recognition (PAR) Approach
%
% *input
%   - data
%   Input struct contains:
%        --- *****/     # Initial-point-specific stride data (vector)
%        	--- time/	# Time of a complete stride (begin with zero)
%        	--- data/	# Global thigh angle corresponds to that stride
%
% *output
%   percent accuracy and confidence index (NOT CORRECTNESS INDEX)
%   # percent accuracy: 
%       # number of correctly classified activities / total number of 
%       # activities
%   # confidence index:
%       # difference of numbers of smaller RMS of subwindows obtained by  
%       # two activities / number of the subwindow
% -------------------------------------------------------------------------

clc;
clear;

% number of correctly classified activities
num.lw = 0;
num.us = 0;
num.ds = 0;

% strides data needed to be recognized into activities
load('Example_100Strides_S4_LW_110SM.mat');
% load('Example_100Strides_S4_SA_110SM.mat');
% load('Example_100Strides_S4_SD_110SM.mat');

% path contains the exemplar phase curves and its associated data
ePath = '../ExampleResult_MPV.mat';

% process of recognizing 
for i=1:length(GaitData)
    TestTime = GaitData(i).time;
    TestValue = GaitData(i).data;
    
    % number of the subwindow
    subwindow = 5;
    
    % template matching with levelWalk exemplar dataset
    % get the divergence rate vector with respect to the levelWalk exemplar
    % dataset
    dWalk = Getdt( TestTime, TestValue, 'LevelWalk', ePath);
    % divide divergence rate vector into subwindows with size 'subwindow' 
    rmsWalk = GetWindowsRMS( dWalk, subwindow );
    
    % template matching with the upStairs exemplar dataset
    dUp = Getdt( TestTime, TestValue, 'UpStairs', ePath);
    rmsUp = GetWindowsRMS( dUp, subwindow );

    % template matching with the downStairs exemplar dataset
    dDown = Getdt( TestTime, TestValue, 'DownStairs', ePath);
    rmsDown = GetWindowsRMS( dDown, subwindow );
    
    % find the activity own most smaller elements within each subwindow
    Smaller = FindSmaller( rmsWalk, 'LevelWalk', rmsUp, 'UpStairs');
    Smaller = FindSmaller( Smaller.par, Smaller.name, rmsDown, 'DownStairs');
    
    % count the number of recognized activities
    switch Smaller.name
        case 'DownStairs'
            num.ds = num.ds + 1;
        case 'UpStairs'
            num.us = num.us + 1;
        case 'LevelWalk'
            num.lw = num.lw + 1;
    end
    
    % display current classified activity's name and its confidence index value
    disp(['Result: ',num2str(i), ' - ' 9 Smaller.name,' ( ',num2str(Smaller.confidence), ' )']); 

end

% display percent proportion of each activity
disp(['Result: LevelWalk',  9, '- ', num2str(num.lw/length(GaitData)*100), '%']);
disp(['Result: UpStairs',   9, '- ', num2str(num.us/length(GaitData)*100), '%']);
disp(['Result: DownStairs', 9, '- ', num2str(num.ds/length(GaitData)*100), '%']);
