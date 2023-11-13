function ops = faceMovAvgMotion(ops)
% to get a averaged frame and motion

ops.t0 = tic;
avgfrm = cell(1,ops.nViews); % frame average of each view
avgmot = cell(1,ops.nViews); % motion average of each view
wpix = ops.wpix;
tpix = ops.tpix;

tp = [0 tpix];
tp = cumsum(tp);
nt0 = min(ops.batchSiz, min(ops.nFrame)); % frames per batch
nbatch = floor(min(ops.maxFr, min(ops.nFrame))/nt0); % number of batches
tlist = round(linspace(1,min(ops.nFrame),nbatch*nt0)); % list to load

fprintf('step1: compute an averaged frame as the baseline\n');

for j = 1:nbatch
    
    im0 = zeros(sum(tpix),nt0,'single'); % concatenates frames of all views
    
    for k = 1:ops.nViews % look at all views
        for t = 1:nt0 % load nt0 frames
            tid = (j - 1) * nt0 + t;
            im = faceMovLoadData(ops,k,tlist(tid));
            im0(tp(k)+1:tp(k+1), t) = im(:);
        end
    end
    
    im0 = double(im0);
    
    if j == 1
        avgframe = zeros(sum(tpix),1,'double');
        avgmotion = zeros(sum(tpix),1,'double');
    end
    
    avgframe  = avgframe + mean(im0, 2);
    avgmotion = avgmotion + mean(abs(diff(im0, 1, 2)), 2);
    
    fprintf('- done %d / %d section in %2.2f sec\n', j, nbatch, toc(ops.t0));

end

avgframe = single(avgframe/double(nbatch));
avgmotion = single(avgmotion/double(nbatch));

for k = 1:ops.nViews
    
    kfrm = avgframe(tp(k)+1:tp(k+1));
    kmot = avgmotion(tp(k)+1:tp(k+1));
    
    if ~isempty(wpix{k})
        avgfrm{k} = kfrm(wpix{k});
        avgmot{k} = kmot(wpix{k});
    else
        avgfrm{k} = kfrm;
        avgmot{k} = kmot;
    end
end

ops.avgframe = avgframe; % average contatenated frame of all pixels
ops.avgmotion = avgmotion; % average contatenated motion of all pixels
ops.avgfrm = avgfrm; % only contains ROI pixels
ops.avgmot = avgmot; % only contains ROI pixels

end

