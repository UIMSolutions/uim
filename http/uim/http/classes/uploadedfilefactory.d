module uim.http.classes.uploadedfilefactory;

import uim.http;

@safe:

/**
 * Factory class for creating uploaded file instances.
 */
class DUploadedFileFactory { //}: IUploadedFileFactory {
    /**
     * Create a new uploaded file.
     *
     * If a size is not provided it will be determined by checking the size of
     * the stream.
     *
     * @param \Psr\Http\Message\IStream stream The underlying stream representing the
     *   uploaded file content.
     * @param string clientFilename The filename as provided by the client, if any.
     * @param string clientMediaType The media type as provided by the client, if any.
     */
    IUploadedFile createUploadedFile(
        IStream stream,
        size_t fileSize = null,
        int fileUploadError = UPLOAD_ERR_OK,
        string aclientFilename = null,
        string aclientMediaType = null
   ) {
        if (fileSize == 0) {
            fileSize = stream.getSize() ?? 0;
        }
        return new UploadedFile(stream, fileSize, fileUploadError, clientFilename, clientMediaType);
    }
}
