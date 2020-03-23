% Script used to implement Phase-Variable-Based (PV) Human Physical 
% Activity Recognition (PAR) Approach
%
% *input
%   - data
%   Input struct contains:
%        ©À©¤©¤ *****/     # Stride data needed to be recognized (vector)
%        	©À©¤©¤ time/	# Time of a complete stride (begin with zero)
%        	©¸©¤©¤ data/	# Global thigh angle corresponds to that stride
% *output
%   percent accuracy
%   # number of correctly classified activities / total number of activities
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
ePath = '../ExampleResult_PV.mat';

% process of recognizing
for i=1:1:length(GaitData)
    TestTime = GaitData(i).time;
    TestValue = GaitData(i).data;
    
    % number of the subwindow (in PV method, this variable is always one)
    subwindow = 1;
    
    % template matching with levelWalk exemplar dataset
    % get the divergence rate with respect to the levelWalk exemplar 
    % dataset
    dWalk = Getdt( TestTime, TestValue, 'LevelWalk', ePath);
   	% divide divergence rate vector into subwindows with size one
    rmsWalk = GetWindowsRMS( dWalk, subwindow );
    
    % template matching with the upStairs exemplar dataset
    dUp = Getdt( TestTime, TestValue, 'UpStairs', ePath);
    rmsUp = GetWindowsRMS( dUp, subwindow );

    % template matching with the downStairs exemplar dataset
    dDown = Getdt( TestTime, TestValue, 'DownStairs', ePath);
    rmsDown = GetWindowsRMS( dDown, subwindow );
    
    % RMS of top 75% divergence rate (used in original paper)
%     limit = 0.75;
% 
%     % levelWalk
%     s = 1:length(dWalk);
%     s = s > (1-limit) * length(dWalk);
%     PArms.w = rms(dWalk(s));
% 
%     % upStairs
%     s = 1:length(dUp);
%     s = s > (1-limit) * length(dUp);
%     PArms.u = rms(dUp(s));
% 
%     % downStairs
%     s = 1:length(dDown);
%     s = s > (1-limit) * length(dDown);
%     PArms.d = rms(dDown(s));
%     
%     pd.w = PArms.w / (PArms.w + PArms.u + PArms.d);
%     pd.s = PArms.s / (PArms.w + PArms.u + PArms.d);
%     pd.d = PArms.d / (PArms.w + PArms.u + PArms.d);

    % find the activity own most smaller elements
    Smaller = FindSmaller( rmsWalk, 'LevelWalk', rmsUp, 'UpStairs');
    Smaller = FindSmaller( Smaller.par, Smaller.name, rmsDown, 'DownStairs');
    
    % count the number of types of recognized activities
    switch Smaller.name
        case 'DownStairs'
            num.ds = num.ds + 1;
        case 'UpStairs'
            num.us = num.us + 1;
        case 'LevelWalk'
            num.lw = num.lw + 1;
    end
    
    % display current classified activity's name
    disp(['Result: ',num2str(i), ' - ' 9 Smaller.name]); 

end

% display percent proportion of each activity
disp(['Result: LevelWalk',  9, '- ', num2str(num.lw/length(GaitData)*100), '%']);
disp(['Result: UpStairs',   9, '- ', num2str(num.us/length(GaitData)*100), '%']);
disp(['Result: DownStairs', 9, '- ', num2str(num.ds/length(GaitData)*100), '%']);