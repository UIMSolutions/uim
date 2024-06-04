module uim.http.classes.clients.formdatapart;

import uim.http;

@safe:

/**
 * Contains the data and behavior for a single
 * part in a Multipart FormData request body.
 *
 * Added to UIM\Http\Client\FormData when sending
 * data to a remote server.
 *
 * @internal
 */
class DFormDataPart { // }: Stringable {
    // Content type to use
    protected string _type;

    // Filename to send if using files.
    mixin(TProperty!("sting", "filename"));

    // The encoding used in this part.
    protected string atransferEncoding = null;

    // The contentId for the part
    protected string _contentId = null;

    this(
        protected string nameOfData,
        protected string ValueOfData,
        protected string dispositionType = "form-data",
        protected string dataCharset = null
    ) {
        // TODO 
    }
    
    /**
     * Get/set the disposition type
     *
     * By passing in `false` you can disable the disposition
     * header from being added.
     */
    void disposition(string adisposition = null) {
        _disposition = disposition;
    }
    string disposition() {
            return _disposition;
    }
    
    // Get/set the contentId for a part.
    string contentId(string _contentId = null) {
        if (_contentId.isNull) {
            return _contentId;
        }
        return _contentId = anId;
    }
    

    
    /**
     * Get/set the content type.
     * Params:
     * string type Use null to get/string to set.
     */
    string type(string atype) {
        if (type.isNull) {
            return _type;
        }
        return _type = type;
    }
    
    /**
     * Set the transfer-encoding for multipart.
     *
     * Useful when content bodies are in encodings like base64.
     * Params:
     * string type The type of encoding the value has.
     */
    string transferEncoding(string atype) {
        if (type.isNull) {
            return _transferEncoding;
        }
        return _transferEncoding = type;
    }
    
    /**
     * Get the part name.
     */
    string name() {
        return _name;
    }
    
    /**
     * Get the value.
     */
    string value() {
        return _value;
    }
    
    /**
     * Convert the part into a string.
     *
     * Creates a string suitable for use in HTTP requests.
     */
    override string toString() {
        string result;
        if (this.disposition) {
             result ~= "Content-Disposition: " ~ this.disposition;
            if (this.name) {
                 result ~= "; " ~ _headerParameterToString("name", this.name);
            }
            if (this.filename) {
                 result ~= "; " ~ _headerParameterToString("filename", this.filename);
            }
             result ~= "\r\n";
        }
        if (this.type) {
             result ~= "Content-Type: " ~ this.type ~ "\r\n";
        }
        if (this.transferEncoding) {
             result ~= "Content-Transfer-Encoding: " ~ this.transferEncoding ~ "\r\n";
        }
        if (this.contentId) {
             result ~= "Content-ID: <" ~ this.contentId ~ ">\r\n";
        }
         result ~= "\r\n";
         result ~= this.value;

        return result;
    }
    
    /**
     * Get the string for the header parameter.
     *
     * If the value contains non-ASCII letters an additional header indicating
     * the charset encoding will be set.
     */
    protected string _headerParameterToString(string headerParameterName, string headerParameterValue) {
        auto transliterated = Text.transliterate(headerParameterValue.replace("\"", ""));
        string result = "%s="%s"".format(headerParameterName, transliterated);
        if (_charset && headerParameterValue != transliterated) {
            result ~= "; %s*=%s""%s".format(headerParameterName, _charset.lower, rawUrlEncode(headerParameterValue));
        }
        return result;
    }
}
