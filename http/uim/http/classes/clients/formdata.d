module uim.http.classes.clients.formdata;

import uim.http;

@safe:

/**
 * Provides an interface for building
 * multipart/form-encoded message bodies.
 *
 * Used by Http\Client to upload POST/PUT data
 * and files.
 */
class DFormData { // }: Countable {
    // Boundary marker.
    protected string _boundary = "";

    // Whether this formdata object has attached files.
    protected bool _hasFile = false;

    // Whether this formdata object has a complex part.
    protected bool _hasComplexPart = false;

    /* 
    // The parts in the form data.
    protected DFFFFFFFormDataPart[] _parts = null;

    // Get the boundary marker
    string boundary() {
        if (_boundary) {
            return _boundary;
        }
       _boundary = md5(uniqid(to!string(time())));

        return _boundary;
    }
    
    /**
     * Method for creating new instances of Part
     * Params:
     * string aName The name of the part.
     */
    FormDataPart newPart(string aName, string valueToAdd) {
        return new DFormDataPart(name, valueToAdd);
    }

    /**
     * Add a new part to the data.
     *
     * The value for a part can be a string, array, int,
     * float, filehandle, or object implementing __toString()
     *
     * If the aValue is an array, multiple parts will be added.
     * Files will be read from their current position and saved in memory.
     * Params:
     * \UIM\Http\Client\FormDataPart|string aName The name of the part to add,
     * or the part data object.
     */
    void add( /* FormDataPart| */ string partName, Json partValue = null) {
        if (isString(partName)) {
            if (isArray(partValue)) {
                this.addRecursive(partName, partValue);
            } else if (isResource(partValue) || cast(IUploadedFile) partValue) {
                this.addFile(partName, partValue);
            } else {
                _parts ~= this.newPart(partName, (string) partValue);
            }
        } else {
            _hasComplexPart = true;
            _parts ~= partName;
        }
    }

    /**
     * Add multiple parts at once.
     * Iterates the parameter and adds all the key/values.
     */
    void addMany(Json[string] data) {
        data.byKeyValue
            .each!(nameValue => add(nameValue.key, nameValue.value));
    }

    // Add either a file reference (string starting with @) or a file handle.
    DFormDataPart addFile(string nameToUse, Json aValue) {
        bool _hasFile = true;

        auto filename = false;
        auto contentType = "application/octet-stream";
        if (cast(IUploadedFile) aValue) {
            content = (string) aValue.getStream();
            contentType = aValue.getClientMediaType();
            filename = aValue.getClientFilename();
        } else if (isResource(aValue)) {
            content = (string) stream_get_contents(aValue);
            if (stream_is_local(aValue)) {
                finfo = new finfo(FILEINFO_MIME);
                metadata = stream_get_meta_data(aValue);
                contentType = (string) finfo.file(metadata["uri"]);
                filename = basename(metadata["uri"]);
            }
        } else {
            finfo = new finfo(FILEINFO_MIME);
            aValue = substr(aValue, 1);
            filename = basename(aValue);
            content = (string) file_get_contents(aValue);
            contentType = (string) finfo.file(aValue);
        }
        part = this.newPart(nameToUse, content);
        part.type(contentType);
        if (filename) {
            part.filename(filename);
        }
        add(part);

        return part;
    }

    /**
     * Recursively add data.
     * Params:
     * string aName The name to use.
     * @param Json aValue The value to add.
     */
    void addRecursive(string nameToUse, Json valueToAdd) {
        valueToAdd.byKeyValue.each!((kv) {
            string key = name ~ "[" ~ kv.key ~ "]";
            add(key, kv.value);
        });
    }

    // Returns the count of parts inside this object.
    size_t count() {
        return count(_parts);
    }

    /**
     * Check whether the current payload
     * has any files.
     */
    bool hasFile() {
        return _hasFile;
    }

    /**
     * Check whether the current payload
     * is multipart.
     *
     * A payload will become multipart when you add files
     * or use add() with a Part instance.
     */
    bool isMultipart() {
        return _hasFile() || _hasComplexPart;
    }

    /**
     * Get the content type for this payload.
     *
     * If this object contains files, `multipart/form-data` will be used,
     * otherwise `application/x-www-form-urlencoded` will be used.
     */
    string contentType() {
        if (!this.isMultipart()) {
            return "application/x-www-form-urlencoded";
        }
        return "multipart/form-data; boundary=" ~ this.boundary();
    }

    /**
     * Converts the FormData and its parts into a string suitable
     * for use in an HTTP request.
     */
    override string toString() {
        if (this.isMultipart()) {
            auto boundary = this.boundary();
            string result = _parts.map!(part => "--%s\r\n%s\r\n".format(boundary, part)).join;
            result ~= "--%s--\r\n".format(boundary);
            return result;
        }
        someData = null;
        _parts.each!(part => someData[part.name()] = part.value());
        return http_build_query(someData);
    }
}
