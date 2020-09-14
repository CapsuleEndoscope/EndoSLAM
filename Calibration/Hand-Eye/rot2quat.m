% rot2quat - converts a rotation matrix (3x3) to a unit quaternion(3x1)
%
%    q = rot2quat(R)
% 
%    R - 3x3 rotation matrix, or 4x4 homogeneous matrix 
%    q - 3x1 unit quaternion
%        q = sin(theta/2) * v
%        teta - rotation angle
%        v    - unit rotation axis, |v| = 1
%
%    
% See also: quat2rot, rotx, roty, rotz, transl, rotvec

function q = rot2quat(R)

	w4 = 2*sqrt( 1 + trace(R(1:3,1:3)) ); % can this be imaginary?
	q = [
		( R(3,2) - R(2,3) ) / w4;
		( R(1,3) - R(3,1) ) / w4;
   	( R(2,1) - R(1,2) ) / w4;
   ];
   
return