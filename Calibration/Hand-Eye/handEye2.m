% handEye - performs hand/eye calibration
% 
%     gHc = handEye(bHg, wHc)
% 
%     bHg - pose of gripper relative to the robot base..
%           (Gripper center is at: g0 = Hbg * [0;0;0;1] )
%           Matrix dimensions are 4x4xM, where M is ..
%           .. number of camera positions. 
%           Algorithm gives a non-singular solution when ..
%           .. at least 3 positions are given
%           Hbg(:,:,i) is i-th homogeneous transformation matrix
%     wHc - pose of camera relative to the world ..      
%           (relative to the calibration block)
%           Dimension: size(Hwc) = size(Hbg)
%     gHc - 4x4 homogeneous transformation from gripper to camera      
%           , that is the camera position relative to the gripper.
%           Focal point of the camera is positioned, ..
%           .. relative to the gripper, at
%                 f = gHc*[0;0;0;1];
%           
% References: R.Tsai, R.K.Lenz "A new Technique for Fully Autonomous 
%           and Efficient 3D Robotics Hand/Eye calibration", IEEE 
%           trans. on robotics and Automaion, Vol.5, No.3, June 1989
%
% Notation: wHc - pose of camera frame (c) in the world (w) coordinate system
%                 .. If a point coordinates in camera frame (cP) are known
%                 ..     wP = wHc * cP
%                 .. we get the point coordinates (wP) in world coord.sys.
%                 .. Also refered to as transformation from camera to world
%

function gHc = handEye2(bHg, wHc)

M = size(bHg,3);

K = (M*M-M)/2;               % Number of unique camera position pairs
A = zeros(3*K,3);            % will store: skew(Pgij+Pcij)
B = zeros(3*K,1);            % will store: Pcij - Pgij
k = 0;

% Now convert from wHc notation to Hc notation used in Tsai paper.
Hg = bHg;
% Hc = cHw = inv(wHc); We do it in a loop because wHc is given, not cHw
Hc = zeros(4,4,M); for i = 1:M, Hc(:,:,i) = inv(wHc(:,:,i)); end;

for i = 1:M,
   for j = i+1:M;
		Hgij = inv(Hg(:,:,j))*Hg(:,:,i);    % Transformation from i-th to j-th gripper pose
		Pgij = 2*rot2quat(Hgij);            % ... and the corresponding quaternion
      
		Hcij = Hc(:,:,j)*inv(Hc(:,:,i));    % Transformation from i-th to j-th camera pose
		Pcij = 2*rot2quat(Hcij);            % ... and the corresponding quaternion

      k = k+1;                            % Form linear system of equations
      A((3*k-3)+(1:3), 1:3) = skew(Pgij+Pcij); % left-hand side
      B((3*k-3)+(1:3))      = Pcij - Pgij;     % right-hand side
      
   end;
end;

% Rotation from camera to gripper is obtained from the set of equations:
%    skew(Pgij+Pcij) * Pcg_ = Pcij - Pgij
% Gripper with camera is first moved to M different poses, then the gripper
% .. and camera poses are obtained for all poses. The above equation uses
% .. invariances present between each pair of i-th and j-th pose.

Pcg_ = A \ B;                % Solve the equation A*Pcg_ = B

% Obtained non-unit quaternin is scaled back to unit value that
% .. designates camera-gripper rotation
Pcg = 2 * Pcg_ / sqrt(1 + Pcg_'*Pcg_);

Rcg = quat2rot(Pcg/2);         % Rotation matrix


% Calculate translational component
k = 0;
for i = 1:M,
   for j = i+1:M;
		Hgij = inv(Hg(:,:,j))*Hg(:,:,i);    % Transformation from i-th to j-th gripper pose
		Hcij = Hc(:,:,j)*inv(Hc(:,:,i));    % Transformation from i-th to j-th camera pose

      k = k+1;                            % Form linear system of equations
      A((3*k-3)+(1:3), 1:3) = Hgij(1:3,1:3)-eye(3); % left-hand side
      B((3*k-3)+(1:3))      = Rcg(1:3,1:3)*Hcij(1:3,4) - Hgij(1:3,4);     % right-hand side
      
   end;
end;

Tcg = A \ B;

gHc = transl(Tcg) * Rcg;	% incorporate translation with rotation


return