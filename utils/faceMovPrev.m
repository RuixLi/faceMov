function faceMovPrev(ops,comp,startFrame)
% show movies and results
% assume maxium 2 video, 1 is body 1 is eye

if ~exist('comp','var'); comp = 1:10; end
tdata = zscore(ops.motSVD(:,comp)); % + 0:3:3*comp;
motLowlim = min(tdata(:));
motHighlim = max(tdata(:));
cm = gray(64);
h1 = figure('Position',[300,450,900,500],'color','w');
vrange = [0,1200];

if exist('startFrame','var')
    t = startFrame;
    vrange = [t, t+1200];
else
    t = 1;
end

while t <= ops.nFrame
    
    try figure(h1); catch; return; end
    subtplot(2,4,[2 3])
    imagesc(ops.movieData(:,:,t));
    axis tight; axis equal; axis off
    colormap(cm)
    drawnow

    try figure(h1); catch; return; end
    subtplot(2,4,5:8)
    plot(tdata)
    ylabel('motion SVD')
    hold on
    line([t,t],[motLowlim,motHighlim],'LineWidth',1,'color','k')
    ylim([motLowlim,motHighlim])
    xlim(vrange)
    hold off
    drawnow
    t = t + 1;
    if t > vrange(2); vrange = vrange + 1200; end
end

close(h1)

end