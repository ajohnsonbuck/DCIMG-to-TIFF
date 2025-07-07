function dcimg_to_tiff(InputFile,OutputFile,HorizontalFlip)

InputFile = char(InputFile);

[Height, Width, NFrames] = dcimg_get_size(InputFile);

TiffOut = Tiff(OutputFile,"w8");
TagStruct = createTiffTag(Height, Width);

for n = 1:NFrames
    Frame = dcimg_read_frame(InputFile, n);
    if HorizontalFlip == true
        Frame = fliplr(Frame);
    end
    
    setTag(TiffOut,TagStruct);
    write(TiffOut,Frame);
    writeDirectory(TiffOut);
end

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