function im = faceMovLoadData(ops, k, fn)
% load and resize the k th tif file in nameList
if fn >= ops.nFrame(k); fn = ops.nFrame(k); end

switch ops.fileType
    case 'mat' % read mat file
        im = ops.matObj.(ops.nameList{k})(:,:,fn);
    case 'stif' % read single tif file
            im = imread(fullfile(ops.dataDir{k},ops.nameList{k}{fn}));
    case 'mtif' % read multipage tif file
        im = ops.tifObj{k}.read(fn);
    case 'avi' % read avi file
        im = read(ops.aviObj{k},fn);
        if size(im,3) > 1; im = im(:,:,1); end
end

%% resize image
ns = 1/ops.sc;
if ns ~= 1; im = imresize(im,ns); end


