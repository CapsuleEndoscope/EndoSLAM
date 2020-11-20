%This code produces depth image. To create point cloud data, points
%matrix(Nx3) is needed to be created. After producing .csv files at the end
%of the code, run points.py to get test.mat file which includes points matrix. 
%Then, run create_ply.m to acquire ply file of the stitched result.

A=imread('<stitched_result>.jpg'); %give the directory of stitched result image
B = rgb2gray( A );

numrow = size(B,1);
numcol = size(B,2);
Y = (1:numrow)./numrow * 72;
X = (1:numcol)./numcol * 72;
Z = (double(B)./255) * 15;

%To see the depth image, uncomment the following block
%surf(X, Y, Z, 'edgecolor', 'none')
%colormap(jet(256));
%axis equal

csvwrite('z.csv',transpose(Z))
csvwrite('y.csv',transpose(Y))
csvwrite('x.csv',transpose(X))