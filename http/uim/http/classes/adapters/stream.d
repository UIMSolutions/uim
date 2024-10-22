/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.adapters.stream;

import uim.http;

@safe:

/**
 * : sending UIM\Http\Client\Request
 * via D`s stream API.
 *
 * This approach and implementation is partly inspired by Aura.Http
 */
class DStream { // }: IAdapter {    // Array of options/content for the HTTP stream context.
    protected Json[string] _contextOptions = null;

    // Array of options/content for the SSL stream context.
    protected Json[string] _sslContextOptions = null;

    // DContext resource used by the stream API.
    protected DContext _context;

    // The stream resource.
    protected DStream _stream;

    // Connection error list.
    protected Json[string] _connectionErrors = null;

    Json[string] send(IRequest request, Json[string] options = null) {
        _stream = null;
        _context = null;
        _contextOptions = null;
        _sslContextOptions = null;
        _connectionErrors = null;

        _buildContext(request, options);

        return _send(request);
    }

    /**
     * Create the response list based on the headers & content
     *
     * Creates one or many response objects based on the number
     * of redirects that occurred.
     * Params:
     * Json[string] requestHeaders The list of headers from the request(s)
     */
    IResponse[] createResponses(Json[string] requestHeaders, string responseContent) {
        auto anIndexes = null;
        auto responses = null;
        foreach (index, aHeader; requestHeaders) {
            if (subString(aHeader, 0, 5).upper == "HTTP/") {
                anIndexes ~= index;
            }
        }
        size_t last = count(anIndexes) - 1;
        foreach (index, start; anIndexes) {
            /** @psalm-suppress InvalidOperand */
            auto end = isSet(anIndexes[index + 1]) ? anIndexes[index + 1] - start : null;
            /** @psalm-suppress PossiblyInvalidArgument */
            auto headerSlice = requestHeaders.slice(start, end);
            string bodyText = index == last ? responseContent : "";
            responses ~= _buildResponse(headerSlice, bodyText);
        }
        return responses;
    }

    // Build the stream context out of the request object.
    protected void _buildContext(IRequest request, Json[string] options = null) {
        _buildContent(request, options);
        _buildHeaders(request, options);
        _buildOptions(request, options);

        auto url = request.getUri();
        auto scheme = parse_url(to!string(url, UIM_URL_SCHEME));
        if (scheme == "https") {
            _buildSslContext(request, options);
        }
        _context = stream_context_create([
            "http": _contextOptions,
            "ssl": _sslContextOptions,
        ]);
    }

    /**
     * Build the header context for the request.
     * Creates cookies & headers.
     */
    protected void _buildHeaders(IRequest request, Json[string] options = null) {
        auto headers = request.getHeaders()
            .byKeyValue
            .map!(kv => "%s: %s".format(kv.key, kv.value.join(", "))).array;

        _contextOptions.set("header", headers.join("\r\n"));
    }

    /**
     * Builds the request content based on the request object.
     *
     * If the request.body() is a string, it will be used as is.
     * Array data will be processed with {@link \UIM\Http\Client\FormData}
     */
    protected void _buildContent(IRequest request, Json[string] options = null) {
        auto requestBody = request.getBody();
        requestBody.rewind();
        _contextOptions.set("content", requestBody.getContents());
    }

    // Build miscellaneous options for the request.
    protected void _buildOptions(IRequest request, Json[string] options = null) {
        _contextOptions
            .set("method", request.getMethod())
            .set("protocol_version", request.getProtocolVersion())
            .set("ignore_errors", true);

        _contextOptions.update("timeout", options.getLong("timeout"));
        // Redirects are handled in the client layer because of cookie handling issues.
        _contextOptions.set("max_redirects", 0);

        if (options.hasKey("proxy.proxy")) {
            _contextOptions
                .set("request_fulluri", true)
                .set("proxy", options.get("proxy.proxy"));
        }
    }

    // Build SSL options for the request.
    protected void _buildSslContext(IRequest request, Json[string] options = null) {
        auto sslOptions = [
            "ssl_verify_peer",
            "ssl_verify_peer_name",
            "ssl_verify_depth",
            "ssl_allow_self_signed",
            "ssl_cafile",
            "ssl_local_cert",
            "ssl_local_pk",
            "ssl_passphrase",
        ];
        if (options.isEmpty("ssl_cafile")) {
            options.set("ssl_cafile", CaBundle.getBundledCaBundlePath());
        }
        if (options.hasKey("ssl_verify_host")) {
            auto url = request.getUri();
            auto host = parse_url(url.toString, UIM_URL_HOST);
            _sslContextOptions.set("peer_name", host);
        }
        sslOptions.each!((key) {
            if (options.asKey(aKey)) {
                auto name = subString(aKey, 4);
                _sslContextOptions.set(name, options.get(aKey));
            }
        });
    }

    // Open the stream and send the request.
    protected Json[string] _send(IRequest request) {
        auto deadline = false;
        if (_contextOptions.getLong("timeout") > 0) {
            /** @var int deadline */
            deadline = time() + _contextOptions.getLong("timeout");
        }
        auto url = request.getUri();
        _open(to!string(url, request));
        string content = "";
        bool timedOut = false;

        assert(_stream !is null, "HTTP stream failed to open");

        while (!feof(_stream)) {
            if (deadline == true) {
                stream_set_timeout(_stream, max(deadline - time(), 1));
            }
            content ~= fread(_stream, 8192);
            meta = stream_get_meta_data(_stream);
            if (meta["timed_out"] || (deadline == true && time() > deadline)) {
                timedOut = true;
                break;
            }
        }
        meta = stream_get_meta_data(_stream);
        /** @psalm-suppress InvalidPropertyAssignmentValue */
        fclose(_stream);

        if (timedOut) {
            throw new DNetworkException("Connection timed out " ~ url, request);
        }

        auto headers = meta["wrapper_data"];
        if (headers.hasKey("headers") && headers.isArray("headers")) {
            headers = headers.get("headers");
        }
        return _createResponses(headers, content);
    }

    // Build a response object
    protected DResponse _buildResponse(Json[string] headers, string requestBody) {
        return new DResponse(headers, requestBody);
    }

    // Open the socket and handle any connection errors.
    protected void _open(string urlToConnect, IRequest request) {
        /* if (!(bool)ini_get("allow_url_fopen")) {
            throw new DClientException("The UIM directive `allow_url_fopen` must be enabled.");
        } */

        /* bool set_error_handler(function (code, message) {
           _connectionErrors ~= message;

            return true;
        });

        try {
            stream = fopen(urlToConnect, "rb", false, _context);
            if (stream == false) {
                stream = null;
            }
           _stream = stream;
        } finally {
            restore_error_handler();
        }

        if (!_stream || _connectionErrors) {
            throw new DRequestException(join("\n", _connectionErrors), request);
        } */
    }

    // Get the context options
    Json[string] contextOptions() {
        return array_merge(_contextOptions, _sslContextOptions);
    }
}
