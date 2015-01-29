function Diagnostic(pre,post,tstr,trackChannel,maxDiam, varargin)
% Diagnostic(pre,post,tstr,2,75,13,231)

for i=1:length(varargin)
minDiameter=[6 8 10 12 14 16];
maxDiameter=maxDiam;
maxNucArea=round(pi*maxDiameter^2/4);
minFormfactor=[.1 .2 .3 .4 .5 .6 .7];
hy = fspecial('sobel');                                                    %Create a predefined 2d filter. "Sobel horizontal edge-emphasizing filter"
hx = hy';
h=varargin{i}
filename=[pre{trackChannel} tstr{h} post{trackChannel}];
im=imread(filename);                                                    %Reads Image.

Iy = imfilter(double(im), hy, 'replicate');                             %N-D filtering on 2D filtered image.
Ix = imfilter(double(im), hx, 'replicate');                             %Across x axis.
e = sqrt(Ix.^2 + Iy.^2);                                                %Create vector of distances between corresponding points.
er=reshape(e,size(e,1)*size(e,2),1);                                    %Reshape array according to distance by sizes of distance of both points.
q1=quantile(er,0.05);                                                 	%Find the value at which 10% of points falls beneath.
q9=quantile(er,0.9);                                                    %Find the value at which 90% of points falls beneath.
thresholds=fliplr(linspace(q1,q9,10));


%Gets the shape value for threshholding.
figure(i), clf;
counter=1;
for k=1:length(minDiameter)
    minNucArea(k)=round(pi*minDiameter(k)^2/4);
    for l=1:length(minFormfactor)
        etlm=zeros(size(im));
        for j=1:length(thresholds)
            et=e>thresholds(j);                                                 %Create an vector from distances that are greater than threshholds
            etl=bwlabel(~et);
            S = regionprops(etl,'EquivDiameter','Area','Perimeter');            %Finds region properties of CC and stores into S.
            nucArea=cat(1,S.Area);                                              %Gets the Area of S.
            nucPerim=cat(1,S.Perimeter);                                        %Gets Perimeter of S.
            nucEquiDiameter=cat(1,S.EquivDiameter);                             %Gets the diameter of a circle with the same area as the region. Computed as sqrt(4*Area/pi).
            nucFormfactor=4*pi*nucArea./(nucPerim.^2);
            shapeScore=nucFormfactor>minFormfactor(l);                         %Returns 1 if statement is true. Else returns 0.
            sizeScore = nucArea>minNucArea(k) & nucArea<maxNucArea;            %Returns 1 if both statements are true. Else returns 0
            totalScore=sizeScore&shapeScore;
            scorenz=find(totalScore);
            for m=1:length(scorenz)                                             %% FILTER BY SCORE
                etlm(etl==scorenz(m))=1;
            end
        end
        subplot(length(minDiameter), length(minFormfactor), counter);
        imshow(im,[]); hold on;
        nmask=etlm;
        nb=bwboundaries(nmask);
        for c=1:size(nb,1)
            mycell=nb(c,:);
            if isempty(mycell{1})
                continue
            else
                dim=mycell{1};
                dim2 = cat(2, dim(:,1),dim(:,2));
                hold on, plot(dim2(:,2),dim2(:,1),'y-');
            end
        end
        str = sprintf('size=%d shape=%g minD=%d', minNucArea(k), round(minFormfactor(l)*100)/100, minDiameter(k))
        title(str);
        counter=counter+1;
    end
end
end