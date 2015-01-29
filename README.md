# CellAnalysisUpdated

For Adith:
This is the pipeline we use for tracking cells and their flourescence. It relies on a sequence of image tiffs which was converted from raw .nd2 files (Nikon's native file format when we take the videos)

Since you're interested in cell death. I suggest you look at the script called qtetest.m and get a feel for how it works.

I have added test tiff files for you to try this on.

Requisites to make this work
- Add this folder to your matlab path using addpath. ex. genpath(addpath('C:\CellAnalysisUpdate'))

On the command line
>> h = 1

Then run lines 4-8 from autorun1.m (highlight the lines and press f9)

To see what you're tracking:

>> movieInfo = qtetest(pre,post,tstr,trackChannel,40,20,.8,1);

You then feed the output to scripTrackGeneral so that it can string together the identified nuclei and create cell tracks (how a single cell moves over time)

>> movieInfo = cat(2, movieInfo{:});
>> scriptTrackGeneral


You can ignore the next lines and move straight to lines 32-34. This line of code reidentifies the cells and uses the tracks 

>> parfor j = 1:5%nWorkers
    valcube{j} = contourtracktest2(pre, post, tstr, tstru{j}, tracksFinal, 40, 20, .8, 1, 630, 128 ,160)
end

Run the rest of the code.

The output is the variable called valcube. 
To see which cells died type:

>> figure, imagesc(valcube(:,:,9) %This displays the ratio channel. 

The y axis is the cell track (ie each row is a cell over time)
The x axis is the time.
The cells that die or divide have tracks that end.

As you can see each function has different inputs. The inputs here are fine tuned for the test tiffs that I have provided. 


Here's a more detailed explanation of the tracking algorithm:
1. Identify cells in each frame (t=1 -> t=max) for each slice/position (xy01 => xyMax)
     a. Since our cell nuclei are dark, the image is inverted so that they are the brightest.
     b. Use matlab threshholding function to find brightest nuclei through space (all bright nuclei 10%>nuclei>90% of all bright nuclei)
     c. Score each bright spot based on circularity and size and filter those that do not meet user input score. 
     d. Get the centroid of each filtered nuclei

2. Create tracks out of tracked nuclei
    a. Using centroids of each nuclei through in each frame for each slice/position, create tracks using probability algorithm.
    b. Probability algorithm uses parameters such as cell trajectory, min consecutive frames before considering a track, and search radius to create tracks. 
    c. Cells are tracked through time for each slice/position

3. Using tracks, re identify cells in each frame using algorithm from 1. and get their values.
    a. Contour slices are now used this time starting from smallest cell to the largest possible cell the algorithm can find.
    b. A cartoon of this is shown below where the characters is a cell
     Contour 1 ->.    
     Contour 2 - >o    
     Contour 3 -> 0       <--- The algorithm chooses this cell because it the largest without breaking the cell
     Contour 4 -> ( )
   
    In this scenario contour 3 is what the cell will be identified as.

4. Get the values for each channel
    a. Nuclear fluorescence is taken by averaging the values of the pixels inside the circle.
    b. Cytosolic fluorescence is taken by dilating the cell a few pixels (3-7 px) and taking the average of the ring created. 

    c. If a FRET reporter is used, the ratio between the CFP and YFP channel is taken. 
