function showimages(images, focus, roi)
% Show image sequence
% SINTAX:
%    preview(images)
%     preview(images, focus)
%     preview(images, focus, roi)
% DESCRIPTION:
% This function displays an image sequence.
% 
% INPUTS:
% images,     is a Px1 a cell array of image paths
% focus,      is a Px1 vector with the focus position of each image
% roi,        is a 4-element vector with the validity region of each
%             image.
% 
% S. Pertuz
% Jan/2016

K = length(images);
TXT = (nargin>1) && ~isempty(focus);
ROI = (nargin>2) && numel(roi)==4;
for k = 1:K
    imshow(images{k})
    if TXT
        str = sprintf('focus = %2.3f [m]',focus(k));
        text(20, 20, str, 'fontsize',...
        14, 'color', [0 1 0]);
    end
    if ROI
        rectangle('position', roi, 'edgecolor', 'b');
    end
    pause(0.02)
end