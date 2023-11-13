function faceMovSave(ops)
save(fullfile(ops.saveFolder,[ops.saveName '.mat']),'-struct','ops','-v7.3')


if isfield(ops, 'movieData')
    % save the movieData into the save folder as an avi file
    v = VideoWriter(fullfile(ops.saveFolder, 'movie_fmd'),"MPEG-4");
        open(v)
        im = newaxis(ops.movieData,3);
        im = rescale(im);
        writeVideo(v, im);
        close(v)
end

end
