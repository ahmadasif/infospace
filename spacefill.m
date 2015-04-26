function numFiles = spacefill(dataDirectory,ellipseColor);


Fs = 1000;            % sampling frequency

fileList = dir(fullfile(dataDirectory,'*.csv'));
dataFiles = {fileList(~[fileList.isdir]).name};
numFiles = size(dataFiles,2);



if (numFiles == 0)
    error('No data files found');end

beginTime=progress('Initializing',0,0,0);

for i = 1:numFiles,

    timeSeries = csvread(fullfile(dataDirectory,dataFiles{i}));
    timeSeries = timeSeries(:,1);
    dataSize = size(timeSeries,1);
  
    if dataSize > 70 && all(timeSeries)
        identifier = fullfile(dataDirectory,dataFiles{i});
        stdTimeSeries = (timeSeries-mean(timeSeries))/std(timeSeries);
        [ng,ngVar] = kurt_sr(stdTimeSeries);
        [nsf,nsfVar] = nsf_new(stdTimeSeries);
        if (ng>=-10) && (ng<=10) && (nsf>=-5) && (nsf<=5)       
            ellipse(sqrt(ngVar),sqrt(nsfVar),0,ng,nsf,ellipseColor);
            hold on;
            text(ng,nsf,dataFiles{i}(1:end-4),'HorizontalAlignment','center','VerticalAlignment','middle');
            drawnow;
        end
        progress(identifier,i,numFiles,beginTime);
    end
    
    hold off;
end

end
