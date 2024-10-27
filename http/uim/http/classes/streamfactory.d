/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
        /* auto myResource = fopen("d://temp", "r+");
        assert(myResource == true, "Unable to create resource");
        fwrite(myResource, contenToPopulate);
        rewind(myResource);

        return _createStreamFromResource(myResource); */
        return null; 
    }
    
    /**
     * Create a stream from an existing file.
     *
     * The file MUST be opened using the given mode, which may be any mode
     * supported by the `fopen` function.
     *
     * The `filename` MAY be any string supported by `fopen()`.
     */
    IStream createStreamFromFile(string filename, string openMode = "r") {
        /* if (!isReadable(filename)) {
            throw new DRuntimeException("Cannot read file `%s`".format(filename));
        }
        return new DStream(filename, openMode); */
        return null;
    }
    
    /**
     * Create a new stream from an existing resource.
     *
     * The stream MUST be readable and may be writable.
     */
    IStream createStreamFromResource(Json[string] resource) {
        // return new DStream(resource);
        return null; 
    }
}
