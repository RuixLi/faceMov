function ops = faceMovDataProjection(ops)
% project data onto SVD motion masks

%%
npix = ops.npix;
np = cumsum([0 npix]);

wVids = ops.wVids;
ncomps = ops.ncomps;
nFrames = ops.nFrame;

imendA = zeros(sum(npix),1,'single');
motSVD = zeros(max(nFrames),ncomps,'single');

fprintf('step3: project data onto SVD masks\n');

nt0 = min(ops.batchSiz, min(nFrames));
nsegs = ceil(max(nFrames)/nt0);

j = 0;
ifr = 0;
nt = nt0;

while ifr < min(nFrames) 

	j = j + 1;
    
    for k = wVids
        nx = ops.nX(k);
        ny = ops.nY(k);
        imb = zeros(ny, nx, nt0, 'single');
        nt = 0;
        
        for t = 1:nt0
            if ifr+nt < ops.nFrame(k)
                nt = nt + 1;
                im = faceMovLoadData(ops,k,ifr+nt);
                imb(:,:,t) = single(im);
            else
                imb = imb(:,:,1:nt);
                break;
            end
        end

        if ismember(k, wVids)
            imd = reshape(imb,[],nt)';
            ima = imd(:,ops.wpix{k}(:))';
            imdiff = abs(diff(cat(2, imendA(np(k)+1:np(k+1)), ima), 1, 2));
            
            if j == 1
                imdiff(:,1) = imdiff(:,2);
            end

            imdiff = bsxfun(@minus, imdiff, ops.avgmot{k});
            motSVD(ifr+1:ifr+nt,:) = motSVD(ifr+1:ifr+nt,:) + ...
                gather_try(imdiff' * ops.uMotMask(np(k)+1:np(k+1),:));
            imendA(np(k)+1:np(k+1)) = ima(:,end);
        end
        
    end
    
    ifr = ifr + nt;
    
    fprintf('- done section %d / %d in %2.2f\n',j, nsegs, toc(ops.t0));
    
end

ops.motSVD = motSVD;
ops.motVariation = std(ops.motSVD,1,1).^2;
ops.motVariation = ops.motVariation';
disp('all finished')
end