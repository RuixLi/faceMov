function ops = faceMovSetROIs(ops,k,fn)
% draw polygon on roi
% faceMap pipeline only watch pixels within ROI
% k: view number

if ~exist('fn','var') || isempty(fn); fn = 1; end

im = double(faceMovLoadData(ops,k,fn));
fov = faceMovRescale(im);

if ~ops.fullFOV
    %% draw ROI
    h = figure('Position', [400,200,480,480]);
    hold on;
    imagesc(fov);
    axis equal; axis ij; axis tight; axis off;
    colormap(gray);
    temproi = drawpolygon;
    waitforclick(temproi);
    bitmap=createMask(temproi);
    squareSize = 16;
    nSquare = round(max(size(fov))/(2*squareSize)) + 1;
    imChecker = checkerboard(squareSize, nSquare, nSquare);
    imCheckerResize = imChecker(1:size(fov,1), 1:size(fov,2));
    masked_img = fov;
    masked_img(bitmap==0) = imCheckerResize(bitmap==0);
    figure(h)
    imagesc(masked_img);
    axis equal; axis ij; axis tight; axis off;
    colormap(gray);
    hold off
else
    bitmap = true(size(fov));
    masked_img = fov;
end

%% add ROI and add video to watch list
ops.ROI{k} = bitmap; % a bit map
ops.ROIfov{k} = masked_img; % a image
ops.wpix{k} = ops.ROI{k}; % pixels within ROIs
ops.npix(k) = sum(ops.wpix{k}(:)); % number of pixels within ROIs

fprintf('ROI in view %d defined\n',k);

pause(0.5)
try close(h); catch; end

end

function pos = waitforclick(hROI)
% Listen for mouse clicks on the ROI
l = addlistener(hROI,'ROIClicked',@clickCallback);
% Block program execution
uiwait;
% Remove listener
delete(l);
% Return the current position
pos = hROI.Position;
end

function clickCallback(~,evt)

if strcmp(evt.SelectionType,'double')
    uiresume;
end

end