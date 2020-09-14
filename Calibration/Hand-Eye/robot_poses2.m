%Load das poses do Robot para guardar na matriz Hhand2world
Poses=importfile('Calib_1.5mm_7x8_.csv',1,4);

[numPoses, numVar]=size(Poses);
Rx=Poses.RX;
Ry=Poses.RY;
Rz=Poses.RZ;

Rhand2world=zeros(3,3,numPoses);
Thand2world=zeros(3, numPoses);
Hhand2world=zeros(4,4,numPoses);
for k=1:numPoses
    Rhand2world(:,:,k) = angle2dcm(Rx(k),Ry(k),Rz(k),'XYZ'); %Euler convention Robot-->XYZ
    Thand2world(:,k) = [Poses.tx(k) Poses.ty(k) Poses.tz(k)]';
    Hhand2world(:,:,k) = [Rhand2world(:,:,k) Thand2world(:,k); [ 0 0 0 1]];
end