%Hand-eye calibration
%
%This add on allows to compute the hand to eye calibration based ont he
%calibration toolbox from Jean-Yves Bouguet
%see http://www.vision.caltech.edu/bouguetj/calib_doc/
%more information can be found here:
%http://www.vision.ee.ethz.ch/~cwengert/calibration_toolbox.php
%
%You need to have computed the intrinsic and extrinsic parameters of your
%camera (the extrinsic parameters with respect to the grid's local
%coordinate system). Then you also need to supply the pose / transformation
%of the robot arm / marker with repsect to the robot base / external
%tracking device in the following format:
%Pack into a 4x4xNumber_of_Views Matrix the following data
%Hmarker2world(:,:,i) = [Ri_3x3 ti_3x1;[ 0 0 0 1]] 
%with 
%i = number of the view, 
%Ri_3x3 the rotation matrix 
%ti_3x1 the translation vector.
%
%The following parameters can be set (if not set the default values are
%used):
%doShow [default=0]: 
%Display the results from the calibration
%doSortHandEyeMovement [default=0]:
%Set this to 1 if you want your views sorted in a way that the interstation
%movement is ideal for hand-eye calibration, see [Tsai]
%HandEyeMethod	[default = 'Tsai']
%Here you specifiy which method you want to use for the
%hand-eye calibration, default is using Tsai's method. See
%ftp://ftp.vision.ee.ethz.ch/publications/proceedings/eth_biwi_00363.pdf
%Possible values are 'Tsai', 'Inria', 'Dual_quaternion', 'Navy'
%Tsai, Inria and Navy give the same results and are usually a bit better
%than the Dual quaternion approach
%
%Christian Wengert
%Computer Vision Laboratory
%ETH Zurich
%Sternwartstrasse 7
%CH-8092 Zurich
%www.vision.ee.ethz.ch/cwengert
%wengert@vision.ee.ethz.ch


%With the doShow flag you can show the results
if(~exist('doShow')) 
    doShow = 0;
end

%Tsai states that the inter-station movement should be as large as possible
%for better accuracy. This flag will sort the movements for higher
%accuracy
if(~exist('doSortHandEyeMovement'))
    doSortHandEyeMovement = 0;
end

%If it does, check whether the Hrobot2hand exists
if(~exist('Hhand2world'))    
    disp(['handeye:: No Hhand2world data available, Hand eye calibration aborted']);
    return
end

%If it does, check whether the Hrobot2hand exists
if(~exist('HandEyeMethod'))    
    HandEyeMethod = 'Tsai';
end

Hmarker2world=Hhand2world;
active_images=1:length(imagesUsed);

%Now go on
disp(['handeye:: Hand-Eye Calibration']);
correctSets = 0;
for i=1:length(active_images)
    if(active_images(i)~=0 && Hmarker2world(1,1,i)~=0) %Make sure its a calibration image and it has tracker info
        %Extract extrinsic parameters
        correctSets = correctSets+1;
        Rc=cameraParams_capsula.RotationMatrices(:,:,i);
        Tc=cameraParams_capsula.TranslationVectors(i,:)';
        Hgrid2cam(:,:,correctSets) = inv(([Rc Tc;[ 0 0 0 1]]));
        Hcam2grid(:,:,correctSets) = inv(Hgrid2cam(:,:,correctSets));
        Hm2w(:,:,correctSets) = Hmarker2world(:,:,active_images(i));
    end
end
if(correctSets)        
    %Remove bad trackerdata
    badTrackerDataIndex = [];
    for i=1:correctSets
        if(abs(Hm2w(1,1,i))<1e-18) %Its bad
            badTrackerDataIndex = [badTrackerDataIndex;i];
            correctSets = correctSets-1;
        end
    end    
    %Init
    Hm2w(:,:,badTrackerDataIndex) = [];
    Hcam2grid(:,:,badTrackerDataIndex) = [];
    Hgrid2cam(:,:,badTrackerDataIndex) = [];
    if(doSortHandEyeMovement)
        index = sortHandEyeMovement(Hm2w);
    else
        index = 1:size(Hm2w,3);          
    end
    Hm2w2 = Hm2w(:,:,index);
    Hcam2grid2 = Hcam2grid(:,:,index);
    %Now calibrate
    switch(HandEyeMethod)
        case 'Tsai'
            [Hcam2marker_, err] = TSAIleastSquareCalibration(Hm2w2, Hcam2grid2)
        case 'Inria'
            [Hcam2marker_, err] = inria_calibration(Hm2w, Hcam2grid2);
        case 'Navy'
            [Hcam2marker_, err] = navy_calibration(Hm2w, Hcam2grid2);
        case 'Dual_quaternion'
            [Hcam2marker_, err] = hand_eye_dual_quaternion(Hm2w, Hcam2grid) ;
    end
    
    %Create the average Hworld2grid, givin an idea where the grid is
    %in the coordinate system of the tracker/robot
    for i=1:correctSets
        Hcam2world_(:,:,i) = Hm2w(:,:,i)*Hcam2marker_;  %Hc2m(:,:,k)
        Hworld2cam_(:,:,i) = inv(Hcam2world_(:,:,i));
        %The above is correct as it gives the same as in my
        %simulation
        Hgrid2world_(:,:,i) = Hcam2world_(:,:,i)*Hcam2grid(:,:,i);
        Hworld2grid_(:,:,i) = inv(Hgrid2world_(:,:,i));
    end
    %Average it, using the algorithm described in ...                
    Hgrid2worldAvg = averageTransformation(Hgrid2world_);
    xd = [];

end
