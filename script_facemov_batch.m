folderList = flist('D:\li\BMdata-20231106','','cg');

nf = length(folderList);

for nn = 1:nf

%%%%%%%%%%% initialize a project for each data %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% root folder contains all simultaneously recorded data
% set root folder to a path to a matfile if use filetype 'mat'
ops.rootFolder = fullfile('D:\li\BMdata-20231106',folderList{nn}); 
ops.saveFolder = ops.rootFolder; % the folder to save processed data
ops.saveName = [filestr(folderList{nn},'n') '_fmd'];
ops.fileType = 'avi'; % 'stif', 'mtif', 'avi', 'mat'
ops.nameList = {'vdata'}; % only required for 'mat'
ops.nFrame = 12001; % number of frames to read
ops.wVids = [1 2]; % video list to watch
ops.sc = 4; % downsample scale
ops.useGPU = 0; % parallel compute toolbox required
ops.fullFOV = false; % use full FOV or not
ops.keepMovie = true; % keep low resolution movie data
ops.batchSiz = 12001; % number of frames each batch
ops.maxFr = 12001; % max frames to get average motion and SVD mask

ops = faceMovInitialize(ops);
for ik = ops.wVids; ops = faceMovSetROIs(ops,ik); end
faceMovSave(ops);
end


%%
%%%%%%%%%%%%%%% batch process the projects %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t0 = tic;
parfor nn = 1:nf
fileName = flist(fullfile('D:\li\BMdata-20231106',folderList{nn}),'mat','fmd');
ops = load(fullfile('D:\li\BMdata-20231106',folderList{nn},fileName{1}));
ops = faceMovAvgMotion(ops);
ops = faceMovSVDMask(ops);
ops = faceMovDataProjection(ops);
ops = faceMovSortData(ops);
faceMovSave(ops)
%clear ops
%loopdisp(folderList,nn,t0)
end