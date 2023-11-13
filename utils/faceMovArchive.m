function im = faceMovArchive(ops)

% combine different sized images as a large image
nK = ops.nViews; % number of images
nX = ceil(ops.nX/2); % number of pixels in x for each image
nY = ceil(ops.nY/2); % number of pixels in y for each image
nFrame = ops.nFrame; % number of frames

% calculate column and row numbers
nCol = ceil(sqrt(nK));
nRow = ceil(nK/nCol);

% calculate the pixel size of the large image
mX = zeros(nRow,nCol)';
mY = zeros(nRow,nCol)';
for kk = 1:nK
    mX(kk) = nX(kk);
    mY(kk) = nY(kk);
end

mX = mX';
mY = mY';

tileX = max(mX,[],1); % max number of pixels in x for each row
tileY = max(mY,[],2); % max number of pixels in y for each column
Xtot = sum(max(mX,[],1)); % total number of pixels in x
Ytot = sum(max(mY,[],2)); % total number of pixels in y

% create the large image
im = zeros(Ytot,Xtot,max(nFrame));

for tt = 1:nFrame
    % fill in the large image
    for kk = 1:nK
        % calculate the row and column number of the image
        row = ceil(kk/nCol);
        col = kk - (row-1)*nCol;
        
        % calculate the pixel number of the image
        x0 = sum(tileX(1:col-1)) + 1;
        x1 = x0 + nX(kk) - 1;
        y0 = sum(tileY(1:row-1)) + 1;
        y1 = y0 + nY(kk) - 1;
        
        % fill in the image
        im(y0:y1,x0:x1,tt) = imresize(faceMovLoadData(ops,kk,tt),0.5);
    end
end

end