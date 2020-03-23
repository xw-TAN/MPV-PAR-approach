function [ m ] = Getm( OriginPoint,LastPoint,NextPoint,Point)
% GETM Computes the magnitude of 'Point'
%
% *input
%   - OriginPoint       # origin/centroid coordinates
%   - LastPoint         # Point before the variable 'Point'
%   - NextPoint         # Point after the variable 'Point'
%   - Point             # Point waited to compute its magnitude
%
% *output
%   - m                 # computed magnitude
% -------------------------------------------------------------------------
%
% x = Point.x       + l(1) * (OriginPoint.x - Point.x)
% x = NextPoint.x   + l(2) * (LastPoint.x   - NextPoint.x)
% y = Point.y       + l(1) * (OriginPoint.y - Point.y)
% y = NextPoint.y   + l(2) * (LastPoint.y   - NextPoint.y)
% AL=b
%
% -------------------------------------------------------------------------

A = [OriginPoint.x-Point.x, -(LastPoint.x-NextPoint.x);...
     OriginPoint.y-Point.y, -(LastPoint.y-NextPoint.y)];
b = [NextPoint.x - Point.x;...
     NextPoint.y - Point.y];

if(det(A) == 0)
    m = 0;
    return;
end
L =  A \ b;

interPoint.x = Point.x + L(1) * (OriginPoint.x-Point.x);
interPoint.y = Point.y + L(1) * (OriginPoint.y-Point.y);

m = sqrt((Point.x-OriginPoint.x)^2+(Point.y-OriginPoint.y)^2)/...
    sqrt((interPoint.x-OriginPoint.x)^2+(interPoint.y-OriginPoint.y)^2);
end

