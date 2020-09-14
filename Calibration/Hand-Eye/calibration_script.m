%low_pose4 = load("/home/capsule2232/Bengisu/calibration/hand-eye2/low_handEye/Poses/4.txt");
%low_pose1(:,:,4) = low_pose4;
robot_poses2;
numPoses = 4;
M=numPoses; %Number of camera positions

bHg = load('Hhand2world.mat').Hhand2world; %4x4x4
    for i=1:M
        bHg(1:3,4,i) = bHg(1:3,4,i)*1000; %conversion from m to mm
    end

Hg=bHg; %Tsai notaion
cam = load('cameraParams.mat');

wHc=zeros(4,4,M);
for i=1:M
    Rc=cameraParams.RotationMatrices(:,:,i);
    Tc=cameraParams.TranslationVectors(i,:)';
    wHc(:,:,i) = [Rc Tc;[ 0 0 0 1]];
end

%gHc = handEye(bHg, wHc)
Hc = zeros(4,4,M); %Tsai notation
for i = 1:M
    Hc(:,:,i) = inv(wHc(:,:,i)); 
end
for j=1:M
    Hg(:,:,j) = inv(Hg(:,:,j));
end
for j=1:M
    Hc(:,:,j) = inv(Hc(:,:,j));
end
    
    
%[Hcam2gripper, err] = TSAIleastSquareCalibration_(Hg, Hc);
[Hcam2gripper] = handEye2(Hg, Hc);
% Hcam2gripper =
%    -0.9610   -0.2506   -0.1166    2.9793
%     0.2002   -0.3403   -0.9187  -27.0224
%     0.1905   -0.9063    0.3773   72.1070
%          0         0         0    1.0000
% err =
%     0.1720
%     3.3877


%%

num_images=4;
A=combinator(4,num_images,'p');

Hgconj=zeros(4,4,num_images);
Hcconj=zeros(4,4,num_images);
Err_rot=zeros(length(A),1);
Err_trans=zeros(length(A),1);
Hcam2gripper_=zeros(4,4,length(A));
for k=1:length(A)
    A_=A(k,:);
    
    for j=1:num_images
        Hgconj(:,:,j)= Hg(:,:,A_(j));
        Hcconj(:,:,j)= Hc(:,:,A_(j));
    end
    
    [Hcam2gripper, err] = TSAIleastSquareCalibration_(Hgconj, Hcconj);
    
    Err_rot(k) = err(1);
    Err_trans(k) = err(2);
    Hcam2gripper_(:,:,k) = Hcam2gripper;
    
end

    [minErr_rot, index_rot] = min(Err_rot);
    [minErr_trans, index_trans] = min(Err_trans);
    Hcam2gripperOptimal_r=Hcam2gripper_(:,:,index_rot);
    Hcam2gripperOptimal_t=Hcam2gripper_(:,:,index_trans);




