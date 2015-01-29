function overlayTracksObjectsMovieC(pre, post, tstr, displayChannel, cbound, nbound, tracksFinal, trackNums)
%overlayTracksObjectsMovieC(pre, post, tstr, 1, cbound, nbound, tracksFinal, 1:size(cbound,2))

newDir=['test_overlay'];
mkdir(newDir);
xCoord=zeros(length(trackNums),length(tstr));
yCoord=zeros(length(trackNums),length(tstr));
vidObj = VideoWriter(['Test.avi']);           %Name
open(vidObj);
for f=1:length(trackNums)
    track=tracksFinal(trackNums(f));
    tca=track.tracksCoordAmpCG;
    soe=track.seqOfEvents;
    xInd=1:8:length(tca);
    yInd=2:8:length(tca);
    startFrame=soe(1,1);
    timeRange=startFrame:(length(xInd)+startFrame-1);
    xCoord(f,timeRange)=tca(1,xInd);
    yCoord(f,timeRange)=tca(1,yInd);
end

for t=1:length(tstr); %loop through time
%     for t=39; %loop through time
    t
    filename=[pre{displayChannel} tstr{t} post{displayChannel}];        %Open Image.
    im=imread(filename);
    h=figure(1),clf; hold on;
    imshow(im,[]); hold on;
    
    
    
    for c=1:length(trackNums)
%         for c=49
        mycell = cbound(t,c);
        if isempty(mycell{1})
            continue
        else
            dim=mycell{1};
            dim2 = cat(2, dim(:,1),dim(:,2));
            hold on, plot(dim2(:,2),dim2(:,1),'-');
        end
    end
    
    for c=1:length(trackNums)
%          for c=49
        mycell = nbound(t,c);
        if isempty(mycell{1})
            continue
        else
            dim=mycell{1};
            dim2 = cat(2, dim(:,1),dim(:,2));
            hold on, plot(dim2(:,2),dim2(:,1),'-');
        end
    end
    
    for p=1:length(trackNums)
%         for p=49
        plot(xCoord(p,t),yCoord(p,t),'co');
        text(xCoord(p,t),yCoord(p,t),num2str(p),'Color','Yellow','FontSize',10);
    end
    
    set(0,'CurrentFigure',1);
    frame = getframe;
    writeVideo(vidObj,frame);
    
end
close(vidObj);
