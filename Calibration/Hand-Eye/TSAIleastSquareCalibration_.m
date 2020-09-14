%This computes the hand-eye calibration using Tsai and Lenz' method
%see the paper "A New Technique for Fully Autonomous and Efficient 3D
%Robotics Hand-Eye Calibration, Tsai, R.Y. and Lenz, R.K" for further
%details
%
%Input:
%Hmarker2world      a 4x4xNumber_of_Views Matrix of the form
%                   Hmarker2world(:,:,i) = [Ri_3x3 ti_3x1;[ 0 0 0 1]] 
%                   with 
%                   i = number of the view, 
%                   Ri_3x3 the rotation matrix 
%                   ti_3x1 the translation vector.
%                   Defining the transformation of the robot hand / marker
%                   to the robot base / external tracking device
%Hgrid2cam          a 4x4xNumber_of_Views Matrix (like above)
%                   Defining the transformation of the grid to the camera
%
%Output:
%Hcam2marker_       The transformation from the camera to the marker /
%                   robot arm
%err                The residuals from the least square processes
%
%Christian Wengert
%Computer Vision Laboratory
%ETH Zurich
%Sternwartstrasse 7
%CH-8092 Zurich
%www.vision.ee.ethz.ch/cwengert
%wengert@vision.ee.ethz.ch
function [Hcam2marker_, err] = TSAIleastSquareCalibration_(Hmarker2world, Hgrid2cam)
    A = [];
    n = size(Hgrid2cam,3);
    for i=1:n-1       %we have n-1 linearly independent relations between the views
        %Transformations between views
        Hgij(:,:,i) = inv(Hmarker2world(:,:,i+1))*Hmarker2world(:,:,i);
        Hcij(:,:,i) = Hgrid2cam(:,:,i+1)*inv(Hgrid2cam(:,:,i)); 
        %turn it into angle axis representation (rodrigues formula: P is
        %the eigenvector of the rotation matrix with eigenvalue 1        
        rgij = rodrigues(Hgij(1:3,1:3,i));        
        rcij = rodrigues(Hcij(1:3,1:3,i));        
        theta_gij = norm(rgij);
        theta_cij = norm(rcij);                        
        rngij = rgij/theta_gij;
        rncij = rcij/theta_cij;
        %Tsai uses a modified version of this         
        Pgij = 2*sin(theta_gij/2)*rngij;
        Pcij = 2*sin(theta_cij/2)*rncij;
        %Now we know that 
        %skew(Pgij+Pcij)*x = Pcij-Pgij  which is equivalent to Ax = b
        %So we need to construct vector b and matrix A to solve this
        %overdetermined system. (Note we need >=3 Views to have at least 2
        %linearly independent inter-view relations.
        A(3*(i-1)+1:i*3,1:3) = crossprod(Pgij+Pcij);
        b(3*(i-1)+1:i*3) = Pcij-Pgij;
    end
    
    %Computing Rotation
    Pcg_prime = pinv(A)*b';
    rank(b)
    %Computing residus
    err = A*Pcg_prime-b'
    residus_TSAI_rotation = sqrt(sum((err'*err))/(n-1));
    Pcg = 2*Pcg_prime/(sqrt(1+norm(Pcg_prime)^2))
    err_Pcg = 2*err/(sqrt(1+norm(Pcg_prime)^2));
    residus_TSAI_rotation_Pcg = sqrt(sum((err_Pcg'*err_Pcg))/(n-1))
    Rcg = (1-norm(Pcg)*norm(Pcg)/2)*eye(3)+0.5*(Pcg*Pcg'+sqrt(4-norm(Pcg)*norm(Pcg))*crossprod(Pcg));
    A = [];
    b = [];
    %Computing Translation
    for i=1:n-1
        A(3*(i-1)+1:i*3,1:3) = (Hgij(1:3,1:3,i) - eye(3));
        b(3*(i-1)+1:i*3) = Rcg*Hcij(1:3,4,i) - Hgij(1:3,4,i);
    end
    Tcg = pinv(A)*b';
    %Computing residus
    err = A*Tcg-b';
    residus_TSAI_translation = sqrt(sum((err'*err))/(n-1));
    %Estimated transformation
    Hcam2marker_ = [Rcg Tcg;[0 0 0 1]];  
    if(nargout==2)
        err = [residus_TSAI_rotation;residus_TSAI_translation];
    end