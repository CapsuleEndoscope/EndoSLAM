clear, clc, close all
%% Load the texture map:
texmap = imread('texture1.tif');

% This will load a 360x360 grayscale image that will be
% used as texture for the sythetic image sequence

%% Generete a synthetical defocus sequence
% 1) Create a directory for saving the simulated images:
mkdir simu01

% 2) Create vector with 15 focus positions between 5 and 50cm: 
focus = linspace(0.05, 0.5, 15);

% 2) Generate a defocus sequence using default parameters:
imdata = simblur(texmap, focus, './simu01', 'display', true);

% This will generate a sequence of 15 images with a 
% cone-shaped depth-map. The output imdata is a structure
% with the fields: images, a 1x15 cell array where
% each cell contains the path to one image of the
% sequence; focus, a 1x15 vector with the focus setting
% corresponding to each image of the sequence; and
% z, a 360x360 matrix with the ground-truth of the
% depth-map.
% 
fprintf('press enter to display generated sequence\n')
pause
%% Show generated image sequence:
close(gcf)
showimages(imdata.images, imdata.focus, imdata.ROI);

% For additional information and usage of this 
% function type:
% 
% >> doc blursequence

