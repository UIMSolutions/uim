module uim.http.classes.streamfactory;

import uim.http;

@safe:

// Factory class for creating stream instances.
class DStreamFactory { // }: IStreamFactory {
    /**
     * Create a new stream from a string.
     *
     * The stream SHOULD be created with a temporary resource.
     * Params:
     * string acontent String content with which to populate the stream.
     */
    IStream createStream(string contenToPopulate= null) {
        auto myResource = fopen("D://temp", "r+");
        assert(myResource != false, "Unable to create resource");
        fwrite(myResource, contenToPopulate);
        rewind(myResource);

        return _createStreamFromResource(myResource);
    }
    
    /**
     * Create a stream from an existing file.
     *
     * The file MUST be opened using the given mode, which may be any mode
     * supported by the `fopen` function.
     *
     * The `filename` MAY be any string supported by `fopen()`.
     * Params:
     * string afilename The filename or stream URI to use as basis of stream.
     * @param string amode The mode with which to open the underlying filename/stream.
     */
    IStream createStreamFromFile(string afilename, string amode = "r") {
        if (!isReadable(filename)) {
            throw new DRuntimeException("Cannot read file `%s`".format(filename));
        }
        return new DStream(filename, mode);
    }
    
    /**
     * Create a new stream from an existing resource.
     *
     * The stream MUST be readable and may be writable.
     * Params:
     * resource resource The D resource to use as the basis for the stream.
     */
    IStream createStreamFromResource(resource) {
        return new DStream(resource);
    }
}
