# faceMov

A MATLAB package to extract body movement with SVD decomposition

Part of the algorithm comes from [facemap](https://github.com/MouseLand/facemap) by Carsen Stringer et al.

also refer to [paper](https://science.sciencemag.org/content/364/6437/eaav7893.abstract) to see how such motion is of interest in system neuroscience

MATLAB relase version >= 2018b is required for some functionalities.

MATLAB image processing toolbox is required.

---

### Inputs

The program can combine synchromized recording data from multiple camera. The program recognize:

1. a series of `tiff` (`.tif` or `.tiff`) files in a folder 
2. multipage `tif` file
3. `avi` file
4. `mat` file, which have data from difference camera saved as difference variables in a single mat file


### Options

`ops.rootFolder`, the folder contains all simultaneously data

* in the case of tif series, it may have subfolders
* in the case of multipage tif or avi, it may have several files, each from a different camera
* in the case of mat file, it will be the path to the mat file but not folder

`ops.saveFolder`, the folder to save processed data

`ops.saveName`, save name

`ops.fileType`, tif series = 'stif', multipage tif = 'mtif', 'avi', 'mat'

`ops.nameList`, not required except for mat file. In the case of `mat`, this will be a list of variable names in the mat file

`ops.nFrame`, number of frames to read

`ops.wVids`, video index to watch

`ops.sc`, downsample scale, if sc is 2, the video data will be downsampled to 1/2

`ops.useGPU`, whether to use parallel compute toolbox for GPU acceleration

`ops.fullFOV`, use full FOV or not, if not, you will need to define a ROI for analysis

`ops.keepMovie`, whether to save a low-resolution movie data in the data

`ops.batchSiz`, number of frames to read and process in each batch

`ops.maxFr`, max frames to get average motion and SVD mask


### Outputs
a `mat` file will be saved in the `ops.saveFolder`. Its name is defined by `ops.saveName`.

data variables in the file are:

`frameAag`, averaged frame

`motionAvg`, averaged motion energy (difference between continous frames)

`motSVD`, SVD temporal components

`motionMasks`, SVD spatial component

`motionTS`, summed SVD temporal components

`motVariation`, variantion of each SVD components

### How to use

after adding the package to MATLAB path, you can check the example script `script_facemov_workflow.m` to run it step by step.

if you have a lot of files to process, use the script `script_facemov_batch.m` to process them in batch.

### Limitations

* The program need to read the same file 3 times, so the IO speed is the bottleneck. It is recommended to use SSD to store the data.

* The GPU acceleration is not very efficient.

* The extracted motion is not explainable. And it is also hard to compare them across different datasets (e.g. different recording from the same animal in different days)