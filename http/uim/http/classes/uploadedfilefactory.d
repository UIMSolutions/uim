/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.uploadedfilefactory;

import uim.http;

@safe:

// Factory class for creating uploaded file instances.
class DUploadedFileFactory { //}: IUploadedFileFactory {
    /**
     * Create a new uploaded file.
     *
     * If a size is not provided it will be determined by checking the size of
     * the stream.
     */
    IUploadedFile createUploadedFile(
        IStream stream,
        size_t fileSize = null,
        int fileUploadError = UPLOAD_ERR_OK,
        string clientFilename = null,
        string clientMediaType = null
   ) {
        if (fileSize == 0) {
            fileSize = stream.getSize() ? stream.getSize() : 0;
        }
        return new UploadedFile(stream, fileSize, fileUploadError, clientFilename, clientMediaType);
    }
}
