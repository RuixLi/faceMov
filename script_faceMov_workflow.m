
%%
%%%%%%%%%%% set parameters %%%%%%%%%%
ops.rootFolder = '/Volumes/CA1/BMdata_test/cg2849_001'; % the folder contains all simultaneously recorded data
ops.saveFolder = '/Volumes/CA1/BMdata_test/cg2849_001'; % the folder to save processed data
ops.saveName = 'cg2849_001_BM';
ops.fileType = 'avi'; % 'stif', 'mtif', 'avi', 'mat'
ops.nameList = {'vdata'}; % only required for 'mat'
ops.nFrame = 12001; % number of frames to read
ops.wVids = [1 2]; % video list to watch
ops.sc = 4; % downsample scale
ops.useGPU = 0; % parallel compute toolbox required
ops.fullFOV = true; % use full FOV or not
ops.keepMovie = true; % keep low resolution movie data
ops.batchSiz = 12001; % number of frames each batch
ops.maxFr = 12001; % max frames to get average motion and SVD mask
ops = faceMovInitialize(ops);

%% 
%%%%%%%%%% set region to analyze for each video %%%%%%%%%%
for ik = ops.wVids
    ops = faceMovSetROIs(ops,ik);
end

%%
%%%%%%%%%%% compute average motion %%%%%%%%%%%%%%%%%W
ops = faceMovAvgMotion(ops);
%% compute SVD mask
ops = faceMovSVDMask(ops);
%% project to svd masks
ops = faceMovDataProjection(ops);
%% sort data
ops = faceMovSortData(ops);

%% 
%%%%%%%%%%% show the results %%%%%%%%%%

%% plot data
view = 1;
comp = 1:5;
frange = 1:600;
faceMovPlot(ops,view,comp,frange)

%% play data
comp = [1 2 3 4 5];
startFr = 1;
faceMovPrev(ops,comp,startFr)

%% 
%%%%%%%%%%% save the results %%%%%%%%%%
faceMovSave(ops)
clear ops
