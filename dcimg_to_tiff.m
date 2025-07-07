function dcimg_to_tiff(InputFile,OutputFile,HorizontalFlip,WaitBarMsg)
% Args
% InputFile: string or char of input path + file to DCIMG file
% OutputFile: string or char of output path + file for TIFF file
% HorizontalFlip: boolean specifying whether to flip image on horizontal
% axis
% WaitBarMsg: message for progress bar

InputFile = char(InputFile);

[Height, Width, NFrames] = dcimg_get_size(InputFile);

TiffOut = Tiff(OutputFile,"w8");
TagStruct = createTiffTag(Height, Width);

wb = waitbar(0,WaitBarMsg);

for n = 1:NFrames
    Frame = dcimg_read_frame(InputFile, n);
    if HorizontalFlip == true
        Frame = fliplr(Frame);
    end
    
    waitbar(n/NFrames,wb);

    setTag(TiffOut,TagStruct);
    write(TiffOut,Frame);
    writeDirectory(TiffOut);
end

close(wb);

TiffOut.close();

end

function TagStruct = createTiffTag(Height, Width)
    TagStruct.ImageLength = Height;
    TagStruct.ImageWidth = Width;
    TagStruct.Photometric = 1;
    TagStruct.BitsPerSample = 16;
    TagStruct.SamplesPerPixel = 1;
    TagStruct.RowsPerStrip = 1024;
    TagStruct.PlanarConfiguration = 1;
    TagStruct.Compression = 1;
end