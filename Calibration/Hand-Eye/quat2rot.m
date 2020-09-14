% quat2rot - a unit quaternion(3x1) to converts a rotation matrix (3x3) 
%
%    R = quat2rot(q)
% 
%    q - 3x1 unit quaternion
%    R - 4x4 homogeneous rotation matrix (translation component is zero) 
%        q = sin(theta/2) * v
%        teta - rotation angle
%        v    - unit rotation axis, |v| = 1
%
% See also: rot2quat, rotx, roty, rotz, transl, rotvec

function R = quat2rot(q)

	p = q'*q;
   if( p > 1 ), 
      disp('Warning: quat2rot: quaternion greater than 1');
   end
   w = sqrt(1 - p);                   % w = cos(theta/2)
   
   R = eye(4);
   R(1:3,1:3) = 2*q*q' + 2*w*skew(q) + eye(3) - 2*diag([p p p]);
   
return