% skew - returns skew matrix of a 3x1 vector. 
%        cross(V,U) = skew(V)*U
%
%    S = skew(V)
%
%          0  -Vz  Vy
%    S =   Vz  0  -Vx  
%         -Vy  Vx  0
%
% See also: cross


function S = skew(V)
	S = [
   	    0    -V(3)    V(2)
        V(3)      0    -V(1)
       -V(2)    V(1)      0
   ];
return
