%TRANSL	Translational transform
%
%	T= TRANSL(X, Y, Z)
%	T= TRANSL( [X Y Z] )
%
%	[X Y Z]' = TRANSL(T)
%
%	[X Y Z] = TRANSL(TG)
%
%	Returns a homogeneous transformation representing a 
%	translation of X, Y and Z.
%
%	The third form returns the translational part of a
%	homogenous transform as a 3-element column vector.
%
%	The fourth form returns a  matrix of the X, Y and Z elements
%	extracted from a Cartesian trajectory matrix TG.
%
%	See also ROTX, ROTY, ROTZ, ROTVEC.

% 	Copyright (C) Peter Corke 1990
function r = transl(x, y, z)
	if nargin == 1,
		if ishomog(x),
			r = x(1:3,4);
		elseif numcols(x) == 16,
			r = x(:,13:15);
		else
			t = x(1:3);
			r =    [eye(3)			t;
				0	0	0	1];
		end
	elseif nargin == 3,
		t = [x; y; z];
		r =    [eye(3)			t;
			0	0	0	1];
    end
    