function ops = faceMovSortData(ops)
% sort data
% change coordinates of pupil data and smooth area

fprintf('step4: sorting data\n')

tpix = ops.tpix;
npix = ops.npix;
tp = cumsum([0 tpix]);
np = cumsum([0 npix]);

for k = 1:ops.nViews
    nx = ops.nX(k);
    ny = ops.nY(k);

    % get average frame and average motion for each viedo
    if ~isfield(ops,'frameAvg')
        ops.frameAvg{k} = reshape(ops.avgframe(tp(k)+1:tp(k+1)), ny, nx);
        ops.motionAvg{k} = reshape(ops.avgmotion(tp(k)+1:tp(k+1)), ny, nx);
    end
    % get svd masks for each viedo
    if isfield(ops,'uMotMask') && ~isempty(ops.uMotMask)
        for n = 1:ops.ncomps
            maskim = zeros(ny,nx);
            maskim(ops.wpix{k}) = ops.uMotMask(np(k)+1:np(k+1),n);
            ops.motionMasks{k}(:,:,n) = maskim;
        end
    end

end

if isfield(ops,'uMotMask') && ~isempty(ops.uMotMask)
    ops.motionTS = sum(abs(ops.motSVD),2);
else
    ops.motSVD = [];   
    ops.motionTS = [];
end

% keep a down sampled movie
if ops.keepMovie
    fprintf('- saving downsampled movie...\n')
    ops.movieData = faceMovArchive(ops);
end

fprintf('All finished after %.2f seconds\n',toc(ops.t0))

try ops = rmfield(ops,"matObj"); catch; end
try ops = rmfield(ops,"tifObj"); catch; end
try ops = rmfield(ops,"aviObj"); catch; end
try ops = rmfield(ops,"avgframe"); catch; end
try ops = rmfield(ops,"avgfrm"); catch; end
try ops = rmfield(ops,"avgmotion"); catch; end
try ops = rmfield(ops,"avgmot"); catch; end
try ops = rmfield(ops,"uMotMask"); catch; end

end

