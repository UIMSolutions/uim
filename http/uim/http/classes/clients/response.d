module uim.http.classes.clients.response;

import uim.http;

@safe:

/**
 * : methods for HTTP responses.
 *
 * All the following examples assume that `response` is an
 * instance of this class.
 *
 * ### Get header values
 *
 * Header names are case-insensitive, but normalized to Title-Case
 * when the response is parsed.
 *
 * ```
 * val = response.getHeaderLine("content-type");
 * ```
 *
 * Will read the Content-Type header. You can get all set
 * headers using:
 *
 * ```
 * response.getHeaders();
 * ```
 *
 * ### Get the response body
 *
 * You can access the response body stream using:
 *
 * ```
 * content = response.getBody();
 * ```
 *
 * You can get the body string using:
 *
 * ```
 * content = response.getStringBody();
 * ```
 *
 * If your response body is in XML or Json you can use
 * special content type specific accessors to read the decoded data.
 * Json data will be returned as arrays, while XML data will be returned
 * as SimpleXML nodes:
 *
 * ```
 * Get as XML
 * content = response.getXml()
 * Get as Json
 * content = response.getJson()
 * ```
 *
 * If the response cannot be decoded, null will be returned.
 *
 * ### Check the status code
 *
 * You can access the response status code using:
 *
 * ```
 * content = response.statusCode();
 * ```
 */
class DClientResponse { // }: Message : IResponse {
    mixin TMessage;

    // The status code of the response.
    protected int _statusCode = 0;

    // The reason phrase for the status code
    protected string _reasonPhrase;

    // Cookie Collection instance
    protected ICookieCollection _cookies = null;

    // Cached decoded XML data.
    protected ISimpleXMLElement _xml = null;

    // Cached decoded Json data.
    protected Json _data = null;

    this(string[] unparsedHeaders = null, string responseBody = null) {
       _parseHeaders(unparsedHeaders);
        if (getHeaderLine("Content-Encoding") == "gzip") {
            responseBody = _decodeGzipBody(responseBody);
        }
        stream = new DStream("D://memory", "wb+");
        stream.write(responseBody);
        stream.rewind();
        this.stream = stream;
    }
    
    /**
     * Uncompress a gzip response.
     *
     * Looks for gzip signatures, and if gzinflate() exists,
     * the body will be decompressed.
     * Params:
     * string abody Gzip encoded body.
     */
    protected string _decodeGzipBody(string encodedBody) {
        if (!function_exists("gzinflate")) {
            throw new UimException("Cannot decompress gzip response body without gzinflate()");
        }
        
        auto anOffset = 0;
        // Look for gzip `signature'
        if (encodedBody.startWith("\x1f\x8b")) {
             anOffset = 2;
        }
        // Check the format byte
        if (substr(encodedBody,  anOffset, 1) == "\x08") {
            return (string)gzinflate(substr(encodedBody,  anOffset + 8));
        }
        throw new UimException("Invalid gzip response");
    }
    
    /**
     * Parses headers if necessary.
     *
     * - Decodes the status code and reasonphrase.
     * - Parses and normalizes header names + values.
     *
     * string[] headersToParse Headers to parse.
     */
    protected void _parseHeaders(string[] headersToParse) {
        foreach (headersToParse as aValue) {
            if (aValue.startWith("HTTP/")) {
                preg_match("/HTTP\/([\d.]+) ([0-9]+)(.*)/i", aValue, matches);
                this.protocol = matches[1];
                _statusCode = to!int(matches[2]);
                this.reasonPhrase = strip(matches[3]);
                continue;
            }
            if (!aValue.has(": ")) {
                continue;
            }
            [name, aValue] = split(": ", aValue, 2);
            aValue = strip(aValue);
            /** @Dstan-var non-empty-string aName */
            string name = strip(name);
            string normalized = name.lower;
            if (_headers.hasKey(name)) {
                _headers[name] ~= aValue;
            } else {
                _headers[name] = /* (array) */aValue;
                this.headerNames[normalized] = name;
            }
        }
    }
    
    /**
     * Check if the response status code was in the 2xx/3xx range
     */
    bool isOk() {
        return _statusCode >= 200 && _statusCode <= 399;
    }
    
    /**
     * Check if the response status code was in the 2xx range
     */
    bool isSuccess() {
        return _statusCode >= 200 && _statusCode <= 299;
    }
    
    /**
     * Check if the response had a redirect status code.
     */
    bool isRedirect() {
        codes = [
            STATUS_MOVED_PERMANENTLY,
            STATUS_FOUND,
            STATUS_SEE_OTHER,
            STATUS_TEMPORARY_REDIRECT,
            STATUS_PERMANENT_REDIRECT,
        ];

        return in_array(_statusCode, codes, true) &&
            getHeaderLine("Location");
    }
    
    @property int statusCode() {
        return _statusCode;
    }
    
    static auto withStatus(int statusCode, string reasonPhrase = null) {
        auto newResponse = clone this;
        newResponse.code = code;
        newResponse.reasonPhrase = reasonPhrase;

        return newResponse;
    }
    
    string getReasonPhrase() {
        return _reasonPhrase;
    }
    
    // Get the encoding if it was set.
    string getEncoding() {
        content = getHeaderLine("content-type");
        if (!content) {
            return null;
        }
        preg_match("/charset\s?=\s?[\']?([a-z0-9-_]+)[\']?/i", content, matches);
        if (isEmpty(matches[1])) {
            return null;
        }
        return matches[1];
    }
    
    // Get the all cookie data.
    Json[string] getCookies() {
        return _getCookies();
    }
    
    /**
     * Get the cookie collection from this response.
     *
     * This method exposes the response`s CookieCollection
     * instance allowing you to interact with cookie objects directly.
     */
    CookieCollection getCookieCollection() {
        return _buildCookieCollection();
    }
    
    /**
     * Get the value of a single cookie.
     * Params:
     * string aName The name of the cookie value.
     */
    string[] getCookie(string aName) {
        cookies = buildCookieCollection();

        if (!cookies.has(name)) {
            return null;
        }
        return cookies.get(name).getValue();
    }
    
    /**
     * Get the full data for a single cookie.
     * Params:
     * string aName The name of the cookie value.
     */
    Json[string] getCookieData(string valueName) {
        cookies = buildCookieCollection();

        if (!cookies.has(valueName)) {
            return null;
        }
        return cookies.get(valueName).toJString();
    }
    
    /**
     * Lazily build the CookieCollection and cookie objects from the response header
     */
    protected ICookieCollection buildCookieCollection() {
        this.cookies ??= CookieCollection.createFromHeader(getHeader("Set-Cookie"));

        return _cookies;
    }
    
    // Property accessor for `this.cookies`
    protected Json[string] _getCookies() {
        auto result;
        this.buildCookieCollection.each!(cookie => result[cookie.name] = cookie.toJString());
        return result;
    }
    
    // Get the response body as string.
    string getStringBody() {
        return _getBody();
    }
    
    // Get the response body as Json decoded data.
    Json getJson() {
        return _getJson();
    }
    
    // Get the response body as Json decoded data.
    protected Json _getJson() {
        if (_Json) {
            return _Json;
        }
        return _Json = Json_decode(_getBody(), true);
    }
    
    // Get the response body as XML decoded data.
    SimpleXMLElement getXml() {
        return _getXml();
    }
    
    // Get the response body as XML decoded data.
    protected ISimpleXMLElement _getXml() {
        if (!_xml.isNull) {
            return _xml;
        }
        libxml_use_internal_errors();
        someData = simplexml_load_string(_getBody());
        if (!someData) {
            return null;
        }

       _xml = someData;
        return _xml;
    }
    
    // Provides magic __get() support.
    protected STRINGAA _getHeaders() {
        STRINGAA results;
        _headers.byKeyValue.each!(kv => results[kv.key] = kv.value.join(","));
        return results;
    }
    
    // Provides magic __get() support.
    protected string _getBody() {
        _stream.rewind();

        return _stream.getContents();
    }
}
