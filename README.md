# MPV-PAR-approach
MPV (Modified Phase-Variable-Based) PAR (Physical Activity Recognition) approach is an extension or modification to original PV (Phase-Variable) method, and can be used to classify level walk, stair ascent and stair descent activities.

# Introduction
This repositary contains Matlab scripts for a method used to classify three types of human physical activities, termed as MPV. MPV is an extension or modification version for original PV method (proposed paper title "A Phase Variable Approach for IMU-Based Locomotion Activity Recognition") which has also been coded in Matlab by ourselves and uploaded into this repositary. Needing to note here is that the coded PV script is NOT provided by the original paper. Although we try hard to replicate the original PV method with Matlab, there may be some small details we have not yet found and coded.
Detailed explanation for MPV method will be found when our paper has been accepted and published.

# Matlab Scripts
- `generateExemplarPhaseCurves.m`
  Script should be used firstly to generate template phase curve and its associated data, such as X and Y coordinates and progression.
  
  1. Example data "Example_Cross_S4.mat" are also provided to run this script.
  2. Data "ExampleResult_MPV.mat" and "ExampleResult_PV.mat" are example result created by this script.
  
- Folder "MPV"
  
  This folder contains the script of MPV method and some associated customized functions.
 
  1. `MPV.m`, main script to implement MPV method with selectable example data "Example_100Strides_S4_LW_110SM.mat", "Example_100Strides_S4_SA_110SM.mat", and "Example_100Strides_S4_SD_110SM.mat".
  2. `Getdt.m`, `Getp.m`, `Getm.m`, `GetWindowsRMS.m`, and `FindSmaller.m` are customized functions that will be called in `MPV.m` script.
  3. Example data mentioned in above are 100 strides at cadence of 110 steps/min for level walk, stair ascent, and stair descent respectively (S4 means the fourth participant).
  
- Folder "PV"
  
  This folder contains the script for PV method and associated functions which are coded by ourselves. Description for this folder can refer to above, and the usage can be found in each scripts' code annotations.
  
