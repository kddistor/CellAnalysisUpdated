function [namePre, namePost, tstr, CFPB, YFPB, sizeThres] = getNames(padding, ifpadded, firsttime, lasttime, separator_pos, order_pos, slideposition, CFPB, YFPB, basename, ch1n, ch2n, ch3n, ch4n, extension, sizeThres)
%   padding: 3 = 001;
%   ifpadded: 1 - padded, 2 - not padded.
%   firstime: first timepoint
%   lasttime: last timepoint
%   separator: 1 - none, 2 - '-', 3 - '_'
%   order:  1 - 't...xy...c...', 2 - 't...c...xy...', 3 - 'xy...t...c...',4 - 'xy...c...t...', 5 - 'c...xy...t...', 6 - 'c...t...xy...'
%   slideposition: 's12'
%   CFPB: CFP BACKGROUND
%   YFPB: YFP BACKGROUND
%   basename: 'basename'
%   ch1n: '1st Channel'
%   ch2n: '2nd Channel'
%   ch3n: '3rd Channel'
%   ch4n: '4th Channel'
%   extension:  eg. 'tif' or 'TIF'
%   sizeThres: [minNucDiameterSize, maxNucDiameterSize]
%   [namePre, namePost, tstr, CFPB, YFPB, sizeThres] = getNames(1, 2, 1, 20, 3, 5, 's12', 650, 1225,'2010-02-04_', 'w1CFP', 'w2YFP', 'w3mRFP1-mCherry', 'c4', 'TIF', [7 25])

% tvec=str2num(firsttime):str2num(lasttime);
tvec=firsttime:lasttime;

switch separator_pos
    case 1
        sepstr='';
    case 2
        sepstr='-';
    case 3
        sepstr='_';
end

switch ifpadded  
    case 1 %padded
        for i=1:length(tvec)
            tp=['000000' num2str(tvec(i))];
            tstr(i)={['t' tp((end-(padding-1)):end)]};
        end
    case 2 %not padded
        for i=1:length(tvec)
            tstr(i)={['t' num2str(tvec(i))]};
        end
end
        
switch order_pos
    case 1 %t...xy...c...
                preT1 =  sprintf('%s', basename);
                preT2 =  sprintf('%s', basename);
                preT3 =  sprintf('%s', basename);
                preT4 =  sprintf('%s', basename);
                postT1 = sprintf('%s%s%s%s.%s',  sepstr, slideposition, sepstr, ch1n, extension);
                postT2 = sprintf('%s%s%s%s.%s',  sepstr, slideposition, sepstr, ch2n, extension);
                postT3 = sprintf('%s%s%s%s.%s',  sepstr, slideposition, sepstr, ch3n, extension);
                postT4 = sprintf('%s%s%s%s.%s',  sepstr, slideposition, sepstr, ch4n, extension);
                namePre={preT1; preT2; preT3; preT4};
                namePost={postT1; postT2; postT3; postT4};
                filename=[preT1, tstr(1) postT1];
                filename=strcat(filename{1:3});
                display(filename)
    case 2 %t...c....xy...
                preT1 =  sprintf('%s', basename);
                preT2 =  sprintf('%s', basename);
                preT3 =  sprintf('%s', basename);
                preT4 =  sprintf('%s', basename);
                postT1 = sprintf('%s%s%s%s.%s',  sepstr, ch1n , sepstr, slideposition, extension);
                postT2 = sprintf('%s%s%s%s.%s',  sepstr, ch2n , sepstr, slideposition, extension);
                postT3 = sprintf('%s%s%s%s.%s',  sepstr, ch3n , sepstr, slideposition, extension);
                postT4 = sprintf('%s%s%s%s.%s',  sepstr, ch4n , sepstr, slideposition, extension);
                namePre={preT1; preT2; preT3; preT4};
                namePost={postT1; postT2; postT3; postT4};
                filename=[preT1, tstr(1), postT1];
                filename=strcat(filename{1:3});
                display(filename)
    case 3 %xy...t...c...
                preT1 =  sprintf('%s%s%s', basename, slideposition, sepstr);
                preT2 =  sprintf('%s%s%s', basename, slideposition, sepstr);
                preT3 =  sprintf('%s%s%s', basename, slideposition, sepstr);
                preT4 =  sprintf('%s%s%s', basename, slideposition, sepstr);
                postT1 = sprintf('%s%s.%s',  sepstr, ch1n, extension);
                postT2 = sprintf('%s%s.%s',  sepstr, ch2n, extension);
                postT3 = sprintf('%s%s.%s',  sepstr, ch3n, extension);
                postT4 = sprintf('%s%s.%s',  sepstr, ch4n, extension);
                namePre={preT1; preT2; preT3; preT4}; 
                namePost={postT1; postT2; postT3; postT4};
                filename=[preT1, tstr(1) postT1];
                filename=strcat(filename{1:3});
                display(filename)
    case 4 %xy...c...t...
                preT1 =  sprintf('%s%s%s%s%s', basename, slideposition, sepstr, ch1n, sepstr);
                preT2 =  sprintf('%s%s%s%s%s', basename, slideposition, sepstr, ch2n, sepstr);
                preT3 =  sprintf('%s%s%s%s%s', basename, slideposition, sepstr, ch3n, sepstr);
                preT4 =  sprintf('%s%s%s%s%s', basename, slideposition, sepstr, ch4n, sepstr);
                postT1 = sprintf('.%s',  extension);
                postT2 = sprintf('.%s',  extension);
                postT3 = sprintf('.%s',  extension);
                postT4 = sprintf('.%s',  extension);
                namePre={preT1; preT2; preT3; preT4}; 
                namePost={postT1; postT2; postT3; postT4};
                filename=[preT1, tstr(1) postT1];
                filename=strcat(filename{1:3});
                display(filename)
    case 5 %c...xy...t...
                preT1 =  sprintf('%s%s%s%s%s', basename, ch1n, sepstr, slideposition, sepstr);
                preT2 =  sprintf('%s%s%s%s%s', basename, ch2n, sepstr, slideposition, sepstr);
                preT3 =  sprintf('%s%s%s%s%s', basename, ch3n, sepstr, slideposition, sepstr);
                preT4 =  sprintf('%s%s%s%s%s', basename, ch4n, sepstr, slideposition, sepstr);
                postT1 = sprintf('.%s',  extension);
                postT2 = sprintf('.%s',  extension);
                postT3 = sprintf('.%s',  extension);
                postT4 = sprintf('.%s',  extension);
                namePre={preT1; preT2; preT3; preT4}; 
                namePost={postT1; postT2; postT3; postT4};
                filename=[preT1, tstr(1) postT1];
                filename=strcat(filename{1:3});
                display(filename)
    case 6 %c...t...xy...
                preT1 =  sprintf('%s%s%s', basename, ch1n, sepstr);
                preT2 =  sprintf('%s%s%s', basename, ch2n, sepstr);
                preT3 =  sprintf('%s%s%s', basename, ch3n, sepstr);
                preT4 =  sprintf('%s%s%s', basename, ch4n, sepstr);
                postT1 = sprintf('%s%s.%s',  sepstr, slideposition, extension);
                postT2 = sprintf('%s%s.%s',  sepstr, slideposition, extension);
                postT3 = sprintf('%s%s.%s',  sepstr, slideposition, extension);
                postT4 = sprintf('%s%s.%s',  sepstr, slideposition, extension);
                namePre={preT1; preT2; preT3; preT4}; 
                namePost={postT1; postT2; postT3; postT4};
                filename=[preT1, tstr(1) postT1];
                filename=strcat(filename{1:3});
                display(filename)
end
