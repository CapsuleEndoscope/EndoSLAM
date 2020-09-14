function imdata = simblur(texmap, focus, impath, varargin)
%Defocus simulation.
% SINTAX:
%   IMDATA = simblur(texmap, focus, impath);
%   IMDATA = simblur(texmap, focus, impath, opt1, val1,...);
%
% DESCRIPTION:
% This function simulates defocus in order to generate
% a focus sequence. It works by mapping a texture (texmap)
% on a predifined depth-map and simulating defocus for
% different focus positions.
%
% INPUTS:
% texmap,       MxN UINT8 grayscale image used as texture.
% focus,        Px1 vector with the focus of each image (in meters)
% impath,       directory where the images will be saved.
%
% Options and their values may be any of the following:
% 'zlimits',    A 2-element vector with the limits of the depthmap measured 
%               in meters. Default is [0.05 0.5].
% 'camera'      A structure with the parameters of the camera: focal length
%               (f) in meters, f-number (N), and pixel density (pitch)
%               in pixels/meter. Default is struct('f',3e-3,'N',1.6,'pitch',1.5e5)
% 'noise',      A scalar betweem 0 and 1 with the noise level. Default is 0.05.
% 'shape',      A string to specify the of the depthmap. It may be either
%               'cone', 'plane', 'cos', or 'sphere'. Default is 'cone'.
% 
% The output IMDATA is a structure with the following fields:
%   images, Px1 cell array with the path of each frame.
%   focus,  Px1 vector with the position of each frame.
%   roi,    A 4-element vector with the validity region of the
%           simulation. Notice that, due to the effects of image
%           borders, the image intensity near image border is less 
%   z,      A MxN ground-truth with the depthmap.
%
%S Pertuz
%Jan/2016

%Default output image format:
fmt = '.png';

% Maximum sigma (pixels). A velue of 6.3706 is recommended for efficiency
% but 15 may be advised for higher accuracy for high defocus levels
% sigma_max = 6.3706;
sigma_max = 15;

[z, camera, noiselevel, dispflag] = parseInputs(size(texmap), varargin{:});
P = length(focus);

fprintf('Blurring     ')
kappa = camera.pitch*camera.f^2/camera.N;   %Camera constant
win = 2*ceil(1.25*sigma_max) + 1;           %NHood size
w = (win - 1)/2;                            %Nhood radius

%Blur kernel index
[x,y] = meshgrid(-w:w, -w:w);
r = sqrt(x.^2 + y.^2);
[M,N] = size(texmap);

% Re-arrange source radiance:
I_0 = im2col(padarray(texmap, [w w], 'symmetric'),...
    [win win], 'sliding');

% Compute each defocused frame
for p = 1:P
    sigma_map = kappa*abs(focus(p)-z)./(focus(p)*z + eps);
    sigma2 = reshape(sigma_map, 1, M*N).^2;    
    W = win*win;
    Gn = zeros(1, M*N);
    
    % Add the contribution of each neighbor:
    for s = 1:W
        Gn = Gn + exp(-r(s).^2./(2*sigma2+eps));       
    end    
    I_n = zeros(1, M*N);
    
    % Normalize image intensity:
    for s = 1:W        
        I_n = I_n + im2double(I_0(s,:)).*...
            (exp(-r(s).^2./(2*sigma2+eps)))./Gn;
    end
    
    frame = reshape(I_n, M, N);
    
    % Add noise
    if (noiselevel > 0)
        frame = addnoise(frame, noiselevel);
    end
    imdata.images{p} = sprintf('%s/im_%02d%s',impath, p, fmt);
    imwrite(frame, imdata.images{p});
    fprintf('\b\b\b\b\b[%02d%%]', round(100*p/P))
end
fprintf(' Ok\n')
imdata.focus = focus;
imdata.z = z;
imdata.ROI = [w+1, w+1, N-2*w-1, M-2*w-1];

% Display simulated scene
if dispflag
    subplot(1,2,1)
    surf(imdata.z, 'cdata', im2double(texmap)), shading flat
    colormap gray, set(gca, 'zdir', 'reverse', 'xtick', [], 'ytick', [])
    box on, title('Textured depthmap'), zlabel('Depth (m)')
    subplot(1,2,2)
    imshow(frame), title('Defocused image')
end


end

function [z, camera, noiselevel, dispflag] = parseInputs(im_size, varargin)
input_data = inputParser;
input_data.CaseSensitive = false;
input_data.StructExpand = false;

input_data.addOptional('display', false, @(x) islogical(x));

input_data.addOptional('shape', 'cone',...
    @(x) any(strcmp(x, {'plane','sphere','cone','cos'})));

input_data.addOptional('zlimits', [0.05 0.5], ...
    @(x) isnumeric(x) && (numel(x)==2));

input_data.addOptional('noise', 0, ...
    @(x) isnumeric(x)&&(x<=1)&&(x>=0));

input_data.addOptional('camera', struct('f', 3e-3, 'N', 1.6, 'pitch', 1.5e5),...
    @(x) isstruct(x));

input_data.parse(varargin{:});
camera = input_data.Results.camera;
noiselevel = input_data.Results.noise;
dispflag = input_data.Results.display;

z0 = input_data.Results.zlimits(1);
z1 = input_data.Results.zlimits(2);

switch input_data.Results.shape
    case 'plane'
        x = linspace(0, 1, im_size(2));
        y = linspace(0, 1, im_size(1))';
        z = y*x;
    case 'sphere'        
        x = linspace(-0.5, 0.5, im_size(2));
        y = linspace(-0.5, 0.5, im_size(1));
        [X,Y] = meshgrid(x,y);
        z = -sqrt(0.5-X.^2-Y.^2);        
    case 'cone'
        x = linspace(-0.5, 0.5, im_size(2));
        y = linspace(-0.5, 0.5, im_size(1));
        [X,Y] = meshgrid(x,y);
        z = sqrt(X.^2+Y.^2);
    case 'cos'
        x = linspace(-3*pi/4, 3*pi/4, im_size(2));
        y = linspace(-3*pi/4, 3*pi/4, im_size(1))';
        z = -cos(y)*cos(x);
end
z = (z1 - z0)*(z - min(z(:)))/(max(z(:)) - min(z(:))) + z0;
end

function Io = addnoise(I, NLevel)
% This function adds and intensity-dependent noise component
% plus gaussian noise.
p = (0.00722*(NLevel-0.1) + 0.0005)/255; 
I(isnan(I)|(I<0)) = 0;
I = imnoise(I, 'localvar', sqrt(p)*I);
Io = imnoise(I, 'gaussian', 0, p);
end