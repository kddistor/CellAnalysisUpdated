% addpath('C:\testTiff')
% matlabpool local
for h=1%:60
xystring = ['xy', num2str(h)]
[pre,post,tstr]=getNames(1,1,1,5,1,5,xystring,1,2,'test_crop','c1','c2','c3','c4','tif',[10 50]);
trackChannel=2;
filename=[pre{trackChannel} tstr{1} post{trackChannel}];
im=double(imread(filename));
parfor i=1:length(tstr)
    movieInfo{i} = qtetest(pre,post,tstr(i),trackChannel,40,20,.8,0);
end
movieInfo = cat(2, movieInfo{:});
scriptTrackGeneral
%Set the number of workers you want to use
%You should indicate more workers than you have data elements (I don't think the code is robust to that)
nWorkers = 9;

%For your application, with tstr (this could be any data that you wanted to splice)
nTime = numel(tstr);

%Pre-define the cell containing the spliced data
tstru = cell(nWorkers,1);
%Calculate the max number of points to put in each cell
nPer = ceil(nTime/nWorkers);

for s = 1:nWorkers
    %Define start and end indices, based on worker count and max points to use
    iSt = (s-1)*nPer+1; iEnd = min(s*nPer, nTime);
    tstru{s} = tstr(iSt:iEnd);
end

parfor j = 1:5%nWorkers
    valcube{j} = contourtracktest2(pre, post, tstr, tstru{j}, tracksFinal, 40, 20, .8, 1, 630, 128 ,160)
end


valcube = cat(2, valcube{:});

%% Get x and y coordinates
for q=1:length(tracksFinal)
    track=tracksFinal(q);
    tca=track.tracksCoordAmpCG;
    soe=track.seqOfEvents;
    xInd=1:8:length(tca);
    yInd=2:8:length(tca);
    startFrame=soe(1,1);
    timeRange=startFrame:(length(xInd)+startFrame-1);
    xCoord(q,timeRange)=tca(1,xInd);
    yCoord(q,timeRange)=tca(1,yInd);
end

valcube(1:end-1,:,13)=xCoord;
valcube(1:end-1,:,14)=yCoord;

%% Save File
filenameCFP=[pre{1} tstru{1} post{1}];
save(['data_xy' filenameCFP{1} 'i.mat']);
displaytext=['-------------------', xystring, ' is done-------------------------'];
disp(displaytext)
end

