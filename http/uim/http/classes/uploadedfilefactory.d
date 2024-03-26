module uim.http.classes.uploadedfilefactory;

import uim.http;

@safe:

/**
 * Factory class for creating uploaded file instances.
 */
class DUploadedFileFactory : UploadedFileFactoryInterface {
    /**
     * Create a new uploaded file.
     *
     * If a size is not provided it will be determined by checking the size of
     * the stream.
     *
     * @link http://php.net/manual/features.file-upload.post-method.d
     * @link http://php.net/manual/features.file-upload.errors.d
     * @param \Psr\Http\Message\IStream stream The underlying stream representing the
     *    uploaded file content.
     * @param int size The size of the file in bytes.
     * @param int error The PHP file upload error.
     * @param string clientFilename The filename as provided by the client, if any.
     * @param string clientMediaType The media type as provided by the client, if any.
     * @throws \InvalidArgumentException If the file resource is not readable.
     */
    auto createUploadedFile(
        IStream stream,
        int size = null,
        int error = UPLOAD_ERR_OK,
        string aclientFilename = null,
        string aclientMediaType = null
    ): IUploadedFile {
        if (size.isNull) {
            size = stream.getSize() ?? 0;
        }
        return new UploadedFile(stream, size, error, clientFilename, clientMediaType);
    }
}
