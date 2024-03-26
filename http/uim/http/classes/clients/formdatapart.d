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
class FormDataPart { // }: Stringable {
    // Content type to use
    protected string _type;

    /**
     * Filename to send if using files.
     * /
    protected string afilename = null;

    /**
     * The encoding used in this part.
     * /
    protected string atransferEncoding = null;

    /**
     * The contentId for the part
     * /
    protected string acontentId = null;

    /**
     * Constructor
     * Params:
     * string aName The name of the data.
     * @param string avalue The value of the data.
     * @param string adisposition The type of disposition to use, defaults to form-data.
     * @param string charset The charset of the data.
     * /
    this(
        protected string aName,
        protected string avalue,
        protected string adisposition = "form-data",
        protected string acharset = null
    ) {
    }
    
    /**
     * Get/set the disposition type
     *
     * By passing in `false` you can disable the disposition
     * header from being added.
     * Params:
     * string disposition Use null to get/string to set.
     * /
    string disposition(string adisposition = null) {
        if (disposition.isNull) {
            return this.disposition;
        }
        return this.disposition = disposition;
    }
    
    /**
     * Get/set the contentId for a part.
     * Params:
     * string  anId The content id.
     * /
    string contentId(string aid = null) {
        if (anId.isNull) {
            return this.contentId;
        }
        return this.contentId =  anId;
    }
    
    /**
     * Get/set the filename.
     *
     * Setting the filename to `false` will exclude it from the
     * generated output.
     * Params:
     * string filename Use null to get/string to set.
     * /
    string filename(string afilename = null) {
        if (filename.isNull) {
            return this.filename;
        }
        return this.filename = filename;
    }
    
    /**
     * Get/set the content type.
     * Params:
     * string type Use null to get/string to set.
     * /
    string type(string atype) {
        if (type.isNull) {
            return this.type;
        }
        return this.type = type;
    }
    
    /**
     * Set the transfer-encoding for multipart.
     *
     * Useful when content bodies are in encodings like base64.
     * Params:
     * string type The type of encoding the value has.
     * /
    string transferEncoding(string atype) {
        if (type.isNull) {
            return this.transferEncoding;
        }
        return this.transferEncoding = type;
    }
    
    /**
     * Get the part name.
     * /
    string name() {
        return this.name;
    }
    
    /**
     * Get the value.
     * /
    string value() {
        return this.value;
    }
    
    /**
     * Convert the part into a string.
     *
     * Creates a string suitable for use in HTTP requests.
     * /
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
     * Params:
     * string aName The name of the header parameter
     * @param string avalue The value of the header parameter
     * /
    protected string _headerParameterToString(string aName, string avalue) {
        transliterated = Text.transliterate(aValue.replace("\"", ""));
        result = "%s="%s"".format(name, transliterated);
        if (this.charset !isNull && aValue != transliterated) {
            result ~= "; %s*=%s""%s".format(name, this.charset.toLower, rawurlencode(aValue));
        }
        return result;
    } */
}
