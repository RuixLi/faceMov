function faceMovPlot(ops,k,ncomp,frange)
% show uMotMask and motSVD

if ~exist('ncomp','var'); ncomp = 1:10; end
   if ~exist('frange','var'); frange = 1:600; end

if ~isfield(ops,'motionMasks') || ~isfield(ops,'motSVD')
    disp('no data')
    return
end

figure('Position',[200,100,500,min(600,length(ncomp)*60)])
cm = lines(length(ncomp));
for i = 1:length(ncomp)
   p = 10*(i-1)+1;
   subtplot(length(ncomp),10,p:p+1)
   imagesc(imgaussfilt(ops.motionMasks{k}(:,:,ncomp(i)),2))
   axis off; axis equal;
   colormap(gca,cmbkr)
   subtplot(length(ncomp),10,p+2:p+9)
   plot(ops.motSVD(frange,ncomp(i)),'LineWidth', 1, 'Color', cm(i,:));
   set(gca,'FontSize',5)
end
end

function map = cmbkr(m)
   %   CMBWR a colour map adopted from matplotlib
   %   cmbwr(M) returns an M-by-3 matrix containing a colormap. 
   %   obtained from Matt Kaufman
   
   if nargin < 1
      f = get(groot,'CurrentFigure');
      if isempty(f)
         m = size(get(groot,'DefaultFigureColormap'),1);
      else
         m = size(f.Colormap,1);
      end
   end
   
   values =[
       1 1.00 0;
       1 0.96 0;
       1 0.92 0;
       1 0.88 0;
       1 0.84 0;
       1 0.80 0;
       1 0.76 0;
       1 0.72 0;
       1 0.68 0;
       1 0.64 0;
       1 0.60 0;
       1 0.56 0;
       1 0.52 0;
       1 0.48 0;
       1 0.44 0;
       1 0.40 0;
       1 0.36 0;
       1 0.32 0;
       1 0.28 0;
       1 0.24 0;
       1 0.20 0;
       1 0.16 0;
       1 0.12 0;
       1 0.08 0;
       1 0.04 0;
       1.00 0 0;
       0.96 0 0;
       0.92 0 0;
       0.88 0 0;
       0.84 0 0;
       0.80 0 0;
       0.76 0 0;
       0.72 0 0;
       0.68 0 0;
       0.64 0 0;
       0.60 0 0;
       0.56 0 0;
       0.52 0 0;
       0.48 0 0;
       0.44 0 0;
       0.40 0 0;
       0.36 0 0;
       0.32 0 0;
       0.28 0 0;
       0.24 0 0;
       0.20 0 0;
       0.16 0 0;
       0.12 0 0;
       0.08 0 0;
       0.04 0 0;
       0.00 0 0;
       0 0 0.04;
       0 0 0.08;
       0 0 0.12;
       0 0 0.16;
       0 0 0.20;
       0 0 0.24;
       0 0 0.28;
       0 0 0.32;
       0 0 0.36;
       0 0 0.40;
       0 0 0.44;
       0 0 0.48;
       0 0 0.52;
       0 0 0.56;
       0 0 0.60;
       0 0 0.64;
       0 0 0.68;
       0 0 0.72;
       0 0 0.76;
       0 0 0.80;
       0 0 0.84;
       0 0 0.88;
       0 0 0.92;
       0 0 0.96;
       0 0 1.00;
       0 0.04 1;
       0 0.08 1;
       0 0.12 1;
       0 0.16 1;
       0 0.20 1;
       0 0.24 1;
       0 0.28 1;
       0 0.32 1;
       0 0.36 1;
       0 0.40 1;
       0 0.44 1;
       0 0.48 1;
       0 0.52 1;
       0 0.56 1;
       0 0.60 1;
       0 0.64 1;
       0 0.68 1;
       0 0.72 1;
       0 0.76 1;
       0 0.80 1;
       0 0.84 1;
       0 0.88 1;
       0 0.92 1;
       0 0.96 1;
       0 1.00 1
       ];
   
   P = size(values,1);
   map = interp1(1:size(values,1), values, linspace(1,P,m), 'linear');
end
