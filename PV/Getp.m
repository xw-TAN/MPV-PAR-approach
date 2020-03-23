function [ pValue,LastPoint,NextPoint ] = Getp( OriginPoint, Point, BaseAngle, PDataset)
%GETP Gets adjacent points to the variable 'Point'
%
% *input
%   - OriginPoint       # origin/centroid coordinates
%   - Point             # Point waited to search its adjacent points
%   - BaseAngle         # Base angle/initial angle of exemplar phase curve
%   - PDataset          # exemplar dataset
%
% *output
%   - pValue            # Progression value
%   - LastPoint         # Point before the variable 'Point'
%   - NextPoint         # Point after the variable 'Point'
% -------------------------------------------------------------------------

% get the phase angle of the 'Point' at exemplar coordinate frame
Angle = atan2((Point.y-OriginPoint.y),(Point.x-OriginPoint.x)) - BaseAngle;
if(Angle < 0)
    PhaseAngle = Angle + 2 * pi;
else
    PhaseAngle = Angle;
end

% search the point after the variable 'Point'
Selection = PDataset.PhaseAngle > PhaseAngle;
% phase angle
theta1 = PDataset.PhaseAngle(find(Selection, 1)-1);
theta2 = PDataset.PhaseAngle(find(Selection, 1));
% progression
p1 = PDataset.pValue(find(Selection, 1)-1);
p2 = PDataset.pValue(find(Selection, 1));
% obtain the adjacent points
LastPoint = PDataset.pPoint(find(Selection, 1)-1);
NextPoint = PDataset.pPoint(find(Selection, 1));
% progression value
pValue = p1+(PhaseAngle - theta1)/(theta2-theta1)*(p2-p1); 

end

