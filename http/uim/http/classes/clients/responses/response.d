/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module http.uim.http.classes.clients.responses.response;

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
    // mixin TMessage;

    // The status code of the response.
    protected int _statusCode = 0;

    // The reason phrase for the status code
    protected string _reasonPhrase;

    // Cookie Collection instance
    protected DCookieCollection _cookies = null;

    // Cached decoded XML data.
    protected ISimpleXMLElement _xml = null;

    // Cached decoded Json data.
    protected Json _data = null;

    this(string[] unparsedHeaders = null, string responseBody = null) {
       _parseHeaders(unparsedHeaders);
        /* if (getHeaderLine("Content-Encoding") == "gzip") {
            responseBody = _decodeGzipBody(responseBody);
        } */
        /* stream = new DStream("d://memory", "wb+");
        stream.write(responseBody);
        stream.rewind();
        this.stream = stream; */
    }
    
    /**
     * Uncompress a gzip response.
     *
     * Looks for gzip signatures, and if gzinflate() exists,
     * the body will be decompressed.
     */
    protected string _decodeGzipBody(string encodedBody) {
        /* if (!function_hasKey("gzinflate")) {
            throw new UIMException("Cannot decompress gzip response body without gzinflate()");
        } */
        
        auto anOffset = 0;
        // Look for gzip `signature'
        if (encodedBody.startsWith("\x1f\x8b")) {
             anOffset = 2;
        }
        // Check the format byte
        /* if (subString(encodedBody,  anOffset, 1) == "\x08") {
            return /* (string) * /gzinflate(subString(encodedBody,  anOffset + 8));
        } */
        throw new UIMException("Invalid gzip response");
    }
    
    /**
     * Parses headers if necessary.
     *
     * - Decodes the status code and reasonphrase.
     * - Parses and normalizes header names + values.
     */
    protected void _parseHeaders(string[] headersToParse) {
        foreach (aValue; headersToParse) {
            if (aValue.startsWith("HTTP/")) {
                /* // preg_match("/HTTP\\/([\d.]+) ([0-9]+)(.*)/i", aValue, matches);
                _protocol = matches[1];
                _statusCode = to!int(matches[2]);
                _reasonPhrase = matches[3].strip;
                continue; */
            }
            if (!aValue.contains(": ")) {
                continue;
            }
            /* [name, aValue] = split(": ", aValue, 2);
            aValue = aValue.strip; */
            /** @Dstan-var non-empty-string aName */
            /* name = name.strip;
            string normalized = name.lower;
            if (_headers.hasKey(name)) {
                _headers[name].concat(aValue);
            } else {
                _headers[name] = /* (array) * /aValue;
                _headerNames[normalized] = name;
            } */
        }
    }
    
    // Check if the response status code was in the 2xx/3xx range
    bool isOk() {
        return _statusCode >= 200 && _statusCode <= 399;
    }
    
    // Check if the response status code was in the 2xx range
    bool isSuccess() {
        return _statusCode >= 200 && _statusCode <= 299;
    }
    
    // Check if the response had a redirect status code.
    bool isRedirect() {
        /* codes = [
            STATUS_MOVED_PERMANENTLY,
            STATUS_FOUND,
            STATUS_SEE_OTHER,
            STATUS_TEMPORARY_REDIRECT,
            STATUS_PERMANENT_REDIRECT,
        ]; */

       /*  return isIn(_statusCode, codes, true) &&
            getHeaderLine("Location"); */
            return false;
    }
    
    @property int statusCode() {
        return _statusCode;
    }
    
    static DClientResponse withStatus(int statusCode, string reasonPhrase = null) {
        /* auto newResponse = this.clone;
        newResponse.code = code;
        newResponse.reasonPhrase = reasonPhrase;

        return newResponse; */
        return null; 
    }
    
    string getReasonPhrase() {
        return _reasonPhrase;
    }
    
    // Get the encoding if it was set.
    string getEncoding() {
        /* auto contentType = getHeaderLine("content-type");
        if (!contentType) {
            return null;
        } */
        // preg_match("/charset\s?=\s?[\']?([a-z0-9-_]+)[\']?/i", content, matches);
        /* if (isEmpty(matches[1])) {
            return null;
        }
        return matches[1]; */
        return null; 
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
    DCookieCollection getCookieCollection() {
        // return _buildCookieCollection();
        return null; 
    }
    
    /**
     * Get the value of a single cookie.
     * Params:
     * string aName The name of the cookie value.
     */
    string[] getCookie(string aName) {
        /* cookies = buildCookieCollection();

        if (!cookies.has(name)) {
            return null;
        }
        return cookies.get(name).value(); */
        return null; 
    }
    
    // Get the full data for a single cookie.
    Json[string] getCookieData(string key) {
        auto cookies = buildCookieCollection();

        /* return cookies.has(valueName)
            ? cookies.get(valueName).toJString()
            : null; */
            return null; 
    }
    
    // Lazily build the CookieCollection and cookie objects from the response header
    protected auto buildCookieCollection() {
        // _cookies ? _cookies : DCookieCollection.createFromHeader(getHeader("Set-Cookie"));
        return _cookies;
    }
    
    // Property accessor for `_cookies`
    protected Json[string] _getCookies() {
        Json[string] result;
        // this.buildCookieCollection.each!(cookie => result[cookie.name] = cookie.toJString());
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
        /* if (_Json) {
            return _Json;
        }
        return _Json = Json_decode(_getBody(), true); */
        return Json(null);
    }
    
    // Get the response body as XML decoded data.
    ISimpleXMLElement getXml() {
        return _getXml();
    }
    
    // Get the response body as XML decoded data.
    protected ISimpleXMLElement _getXml() {
        /* if (!_xml.isNull) {
            return _xml;
        } */

        /* libxml_use_internal_errors(); */
        /* someData = simplexml_load_string(_getBody());
        if (!someData) {
            return null;
        }

       _xml = someData; */
        return _xml;
    }
    
    // Provides magic __get() support.
    protected STRINGAA _getHeaders() {
        STRINGAA results;
        // _headers.byKeyValue.each!(kv => results[kv.key] = kv.value.join(","));
        return results;
    }
    
    // Provides magic __get() support.
    protected string _getBody() {
        /* _stream.rewind();

        return _stream.getContents(); */
        return null; 
    }
}
