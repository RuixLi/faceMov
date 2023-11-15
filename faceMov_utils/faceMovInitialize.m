function ops = faceMovInitialize(ops)

% initialization
ops.tpix = []; % total pixel number of each view
s = dir(ops.rootFolder);
fisdir = [s.isdir];

switch ops.fileType
    case 'stif' % tiff series
        
        if sum(fisdir) < 3 && sum(fisdir) > 0

            % case 1 the data in the rootfolder is a series of tiff files
            ops.nViews = 1;
            ops.dataDir{1} = ops.rootFolder;
            [namelist, ops.nFrame] = faceMovGetFilesName(ops.dataDir{1},'tif*');
            ops.nameList{1} = namelist;
            [ops.nY, ops.nX] = size(faceMovLoadData(ops,1,1));
            ops.tpix = ops.nY*ops.nX;
            fprintf('find 1 recording with %d frames\n', ops.nFrame)

        elseif sum(fisdir) >= 3 && strcmpi(ops.fileType,'stif')
            
            % case 2 root folder contains several subfolder
            dirId = find(fisdir(3:end)) + 2;
            p = 1;
            for k = dirId
                ops.dataDir{p} = fullfile(s(k).folder,s(k).name);
                [namelist, nframe] = getFilesNameLocal(ops.dataDir{p},'tif*');
                
                if ~isempty(namelist)
                    ops.nameList{p} = namelist;
                    ops.nFrame(p) = nframe;
                    [ops.nY(p), ops.nX(p)] = size(faceMovLoadData(ops,p,1));
                    ops.tpix(p) = ops.nY(p)*ops.nX(p);
                    p = p + 1;
                end

            end
            p = p - 1;
            fprintf('find %d recordings with %s frames\n', p, num2str(ops.nFrame))
            ops.nViews = p;
        end

    case 'mtif' % multi-tiff file
        ops.dataDir{1} = ops.rootFolder;
        [namelist, ops.nViews] = faceMovGetFilesName(ops.dataDir{1},'tif*');
        ops.nameList = namelist;
        for p = 1:ops.nViews
            ops.tifObj{p} = Tiff(fullfile(ops.dataDir{1},ops.nameList{p}));
            ops.nFrame(p) = ops.tifObj{p}.NumberOfFrames;
            ops.nY(p) = ceil(ops.tifObj{p}.TagStruct.ImageLength/ops.sc);
            ops.nX(p) = ceil(ops.tifObj{p}.TagStruct.ImageWidth/ops.sc);
            ops.tpix(p) = ops.nY(p)*ops.nX(p);
        end
        fprintf('find %d recordings with %s frames\n', ops.nViews, num2str(ops.nFrame))

    case 'mat' % root folder is a mat file
        ops.dataDir{1} = ops.rootFolder;
        ops.nViews = length(ops.nameList);
        ops.matObj = matfile(ops.rootFolder, 'Writable', false);
        for p = 1:ops.nViews
            if ~isfield(ops,'nFrame') || isempty(ops.nFrame)
                ops.nFrame(p) = size(ops.matObj.(ops.nameList{p}),3);
            end
            [ops.nY(p), ops.nX(p)] = size(faceMovLoadData(ops,p,1));
            ops.tpix(p) = ops.nY(p)*ops.nX(p);        
        end
        fprintf('find %d recordings with %s frames\n', ops.nViews, num2str(ops.nFrame))

    case 'avi' % avi file
        ops.dataDir{1} = ops.rootFolder;
        [namelist, ops.nViews] = faceMovGetFilesName(ops.dataDir{1},'avi');
        ops.nameList = namelist;
        for p = 1:ops.nViews
            ops.aviObj{p} = VideoReader(fullfile(ops.dataDir{1},ops.nameList{p}));
            ops.nFrame(p) = ops.aviObj{p}.NumberOfFrames;
            ops.nY(p) = ceil(ops.aviObj{p}.Height/ops.sc);
            ops.nX(p) = ceil(ops.aviObj{p}.Width/ops.sc);
            ops.tpix(p) = ops.nY(p)*ops.nX(p);
        end
        fprintf('find %d recordings with %s frames\n', ops.nViews, num2str(ops.nFrame))

end

ops.ROI = cell(1,ops.nViews); % ROI in each view
ops.ROImap = cell(1,ops.nViews); % ROImap in each view
ops.wpix = cell(1,ops.nViews); % pixel indeces to watch in each view
ops.npix = zeros(1,ops.nViews); % pixel number to watch in each view

end
