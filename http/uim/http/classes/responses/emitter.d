module uim.http.classes.responses.emitter;

import uim.http;

@safe:

// Emits a Response to the UIM Server API.
class DResponseEmitter {
    // Maximum output buffering size for each iteration.
    protected int maxBufferLength;

    /**
     
     * Params:
     * int maxBufferLength Maximum output buffering size for each iteration.
     */
    this(int maxBufferLength = 8192) {
        this.maxBufferLength = maxBufferLength;
    }
    
    /**
     * Emit a response.
     *
     * Emits a response, including status line, headers, and the message body,
     * according to the environment.
     * Params:
     * \Psr\Http\Message\IResponse response The response to emit.
     */
   bool emit(IResponse response) {
        string file = "";
        auto line = 0;
        if (headers_sent(file, line)) {
            string message = "Unable to emit headers. Headers sent in file=file line=line";
            trigger_error(message, ERRORS.USER_WARNING);
        }
        emitStatusLine(response);
        emitHeaders(response);
        flush();

        auto range = this.parseContentRange(response.getHeaderLine("Content-Range"));
        if (isArray(Json[string])) {
            this.emitBodyRange(Json[string], response);
        } else {
            this.emitBody(response);
        }
        if (function_hasKey("fastcgi_finish_request")) {
            fastcgi_finish_request();
        }
        return true;
    }
    
    /**
     * Emit the message body.
     * Params:
     * \Psr\Http\Message\IResponse response The response to emit
     */
    protected void emitBody(IResponse response) {
        if (isIn(response.statusCode(), [204, 304], true)) {
            return;
        }
        body = response.getBody();

        if (!body.isSeekable()) {
            writeln(body;

            return;
        }
        body.rewind();
        while (!body.eof()) {
            writeln(body.read(this.maxBufferLength);
        }
    }
    
    // Emit a range of the message body.
    protected void emitBodyRange(Json[string] dataToEmit, IResponse responseToEmit) {
        [, first, last] = dataToEmit;

        auto responseBody = responseToEmit.getBody();

        if (!responseBody.isSeekable()) {
            contents = responseBody.getContents();
            writeln(subString(contents, first, last - first + 1));

            return;
        }

        auto streamBody = new DRelativeStream(responseBody, first);
        streamBody.rewind();
        
        size_t pos = 0;
        size_t length = last - first + 1;
        while (!streamBody.eof() && pos < length) {
            if (pos + _maxBufferLength > length) {
                writeln(streamBody.read(length - pos));
                break;
            }
            writeln(streamBody.read(this.maxBufferLength));
            pos = streamBody.tell();
        }
    }
    
    /**
     * Emit the status line.
     *
     * Emits the status line using the protocol version and status code from
     * the response; if a reason phrase is available, it, too, is emitted.
     * Params:
     * \Psr\Http\Message\IResponse response The response to emit
     */
    protected void emitStatusLine(IResponse response) {
        reasonPhrase = response.getReasonPhrase();
        header("HTTP/%s %d%s"
            .format(response.getProtocolVersion(),
            response.statusCode(),
            (reasonPhrase ? " " ~ reasonPhrase : "")
       ));
    }
    
    /**
     * Emit response headers.
     *
     * Loops through each header, emitting each; if the header value
     * is an array with multiple values, ensures that each is sent
     * in such a way as to create aggregate headers (instead of replace
     * the previous).
     */
    protected void emitHeaders(IResponse response) {
        auto cookies = null;
        if (cast(DResponse)response) {
            cookies = iterator_to_array(response.getCookieCollection());
        }
        foreach (name, someValues; response.getHeaders()) {
            if (name.lower == "Set-cookie") {
                cookies = array_merge(cookies,  someValues);
                continue;
            }
            auto first = true;
            foreach (aValue; someValues) {
                header(
                    "%s: %s".format(
                    name,
                    aValue
               ), first);
                first = false;
            }
        }
        this.emitCookies(cookies);
    }
    
    // Emit cookies using setcookie()
    protected void emitCookies(Json[string] cookies) {
        cookies.each!(cookie => setCookie(cookie));
    }
    
    // Helper methods to set cookie.
    protected bool setCookie(string acookie) {
        return setCookie(Cookie.createFromHeaderString(cookie, ["path": ""]));
    }
    protected bool setCookie(ICookie acookie) {
        return setcookie(cookie.name, cookie.getScalarValue(), cookie.getOptions());
    }
    
    /**
     * Loops through the output buffer, flushing each, before emitting
     * the response.
     * Params:
     * int maxBufferLevel Flush up to this buffer level.
     */
    protected void flush(int maxBufferLevel = null) {
        maxBufferLevel ? maxBufferLevel : ob_get_level();

        while (ob_get_level() > maxBufferLevel) {
            ob_end_flush();
        }
    }
    
    // Parse content-range header
    protected array|false parseContentRange(string header) {
        if (preg_match("/(?P<unit>[\w]+)\s+(?P<first>\d+)-(?P<last>\d+)\/(?P<length>\d+|\*)/",  aHeader, matches)) {
            return [
                matches["unit"],
                matches.getLong("first"),
                matches.getLong("last"),
                matches.getString("length") == "*" ? "*" : matches.getLong("length"),
            ];
        }
        return false;
    }
}
