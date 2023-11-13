function ops = faceMovSVDMask(ops)
% get motion masks

npix = ops.npix;
np = cumsum([0 npix]);
nFrame = ops.nFrame;
wVids = ops.wVids;

wfr = ops.maxFr; % max frame to watch
nt0 = min(ops.batchSiz, min(nFrame));
ncomps = min(min(nFrame)-2,200);

nsegs = min(floor(wfr/nt0), floor(min(nFrame)/nt0));

ims = zeros(sum(npix),nt0,'single');
uMot = [];

fprintf('step2: compute SVD masks\n');

%% get SVD masks for each batch
for j = 1:nsegs
    for k = wVids
        if ismember(k,wVids)
            for t = 1:nt0
                tid = (j - 1) * nt0 + t;
                im = faceMovLoadData(ops,k,tid);
                ims(np(k)+1:np(k+1), t) = im(ops.wpix{k}(:));              
            end
        end
    end

    if ~isempty(ims)
        imot = bsxfun(@minus, abs(diff(ims,1,2)), cat(1,ops.avgmot{:}));
        if ops.useGPU; imot = gpuArray(imot); end
        [u, ~, ~] = svdecon(imot);
        u = gather_try(u);
        uMot = cat(2, uMot, u(:,1:min(ncomps,size(u,2))));
    end
   
    fprintf('done %d / %d in %2.2f sec\n',j, nsegs, toc(ops.t0));

end

%% get SVD masks from batch SVD masks
clear imot;
[u, ~, ~]  = svdecon(uMot);
uMotMask = gather_try(u(:,1:min(ncomps,size(u,2))));
uMotMask = normcc(uMotMask);
ops.uMotMask = uMotMask;
ops.ncomps = ncomps;

end

function y = normcc(x)
y = bsxfun(@times, x, 1./(sum(x.^2,1).^0.5));
end