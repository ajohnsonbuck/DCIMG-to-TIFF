function Canceled = dcimg_to_tiff(InputFile,OutputFile,HorizontalFlip,WaitTitle)
% Args
% InputFile: (string or char) input path + file to DCIMG file
% OutputFile: (string or char) output path + file for TIFF file
% HorizontalFlip: (bool) whether to flip image on horizontal
% axis
% WaitTitle: (str) Title for progress bar window
%
% Output
% Canceled (bool): whether conversion has been canceled

Canceled = false;
InputFile = char(InputFile); % convert to char for compatibility with MEX functions

[Height, Width, NFrames] = dcimg_get_size(InputFile); % Get height, width, and number of frames

% Initialize TIFF and tag structure
TiffOut = Tiff(OutputFile,"w8"); 
TagStruct = createTiffTag(Height, Width);

% Initialize progress bar
wb = waitbar(0,strjoin(["Completed 0 of ",num2str(NFrames), " frames."]),'Name',WaitTitle,'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

for n = 1:NFrames
    % Read the current frame from the DCIMG file and apply optional flip
    Frame = dcimg_read_frame(InputFile, n);
    if HorizontalFlip == true
        Frame = fliplr(Frame);
    end
    
    % Update progress bar
    waitbar(n/NFrames,wb,strjoin(["Completed ",num2str(n)," of ",num2str(NFrames), " frames."]));

    % Write TIFF frame
    setTag(TiffOut,TagStruct);
    write(TiffOut,Frame);
    writeDirectory(TiffOut);

    if getappdata(wb,'canceling')
        Canceled = true;
        break;
    end
end

delete(wb);

TiffOut.close();

end

function TagStruct = createTiffTag(Height, Width)
    % Create tag for TIFF file; currently certain values hardcoded since
    % can't extract from DCIMG format with existing MEX files
    TagStruct.ImageLength = Height;
    TagStruct.ImageWidth = Width;
    TagStruct.Photometric = 1;
    TagStruct.BitsPerSample = 16;
    TagStruct.SamplesPerPixel = 1;
    TagStruct.RowsPerStrip = 1024;
    TagStruct.PlanarConfiguration = 1;
    TagStruct.Compression = 1;
end