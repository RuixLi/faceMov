function [filelist, nFiles] = faceMovGetFilesName(pathname, ext, textInName, textNotInName, indx)

% retursn file names in a given folder, GUI select if no input

% INPUT
% -if no input, trigger GUI to select a folder
% pathname[str], path name string
% ext[str], extention string (without dot) (optioanl)
% textInName[str], key word to include (optioanl)
% textNotInName[str], key word to exclude (optioanl)
% indx[vector], the index of file list (order by name) to return (optioanl)

% OUTPUT
% filelist[Nx1 cell], a N x 1 cell contains filename
% nFiles, number of matched file

% modified by Ruix.Li in Jul, 2020 from GETALLFILENAMES
% -rename from getfillNames in Oct, 2020
% -updated in Jan, 2021

if nargin < 5; indx = []; end
if nargin < 4 || isempty(textNotInName); textNotInName = ''; end
if nargin < 3 || isempty(textInName); textInName = ''; end
if nargin < 2 || isempty(ext); ext = []; end
if nargin == 0 || isempty(pathname); pathname = uigetdir; end

if exist(pathname,'dir')
    %% list directory
    list = dir(pathname); 
    list(1:2)=[];  % remove '.' and '..'
    filelist = {list.name};
    
    if isempty(filelist)
        error('No files found at path %s', pathname);
    end

    %% first restrict by indices passed in
    if ~isempty(indx)
        filelist = filelist(indx);
    end
    
    %% remove files with other extensions
    if ~isempty(ext)
    rMatchNs = regexpi(filelist, ['\.(', ext, ')$']);
    filelist = filelist(~cellfun(@isempty, rMatchNs));
    end
    
    %% restrict list by text str if necessary
    if ~isempty(textInName)
        rMatchNs = regexpi(filelist, textInName);
        filelist = filelist(~cellfun(@isempty, rMatchNs));
    end
    if ~isempty(textNotInName)
        rMatchNs = regexpi(filelist, textNotInName);
        filelist = filelist(cellfun(@isempty, rMatchNs));
    end
        
    %---  must have full list by the time we hit here, sorting below

    nFiles = length(filelist);
    filelist = filelist';
    
    %% check number resulting
    % fprintf(1,'found %i files \n', nFiles);
 
else  % could not find directory/file
    error('pathname does not exist: %s', pathname);
end
end