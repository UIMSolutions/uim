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

    /**
     * DContext resource used by the stream API.
     *
     * @var resource|null
     * /
    protected _context;



    /**
     * The stream resource.
     *
     * @var resource|null
     * /
    protected _stream;

    /**
     * Connection error list.
     * /
    // TODO protected Json[string] _connectionErrors = null;

    array send(IRequest request, Json[string] options = null) {
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
     * array  aHeaders The list of headers from the request(s)
     * @param string acontent The response content.
     * /
    Response[] createResponses(Json[string]  aHeaders, string acontent) {
         anIndexes = responses = null;
        foreach (aHeaders as  anI:  aHeader) {
            if (substr(aHeader, 0, 5).toUpper == "HTTP/") {
                 anIndexes ~= anI;
            }
        }
        last = count(anIndexes) - 1;
        foreach (anIndexes as  anI: start) {
            /** @psalm-suppress InvalidOperand * /
            end = isSet(anIndexes[anI + 1]) ?  anIndexes[anI + 1] - start : null;
            /** @psalm-suppress PossiblyInvalidArgument * /
             aHeaderSlice = array_slice(aHeaders, start, end);
            body = anI == last ? content : "";
            responses ~= _buildResponse(aHeaderSlice, body);
        }
        return responses;
    }
    
    /**
     * Build the stream context out of the request object.
     * Params:
     * \Psr\Http\Message\IRequest request The request to build context from.
     * @param Json[string] options Additional request options.
     * /
    protected void _buildContext(IRequest request, Json[string] options = null) {
       _buildContent(request, options);
       _buildHeaders(request, options);
       _buildOptions(request, options);

        url = request.getUri();
        scheme = parse_url(to!string(url, UIM_URL_SCHEME));
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
     *
     * Creates cookies & headers.
     * Params:
     * \Psr\Http\Message\IRequest request The request being sent.
     * @param Json[string] options Array of options to use.
     * /
    protected void _buildHeaders(IRequest request, Json[string] options = null) {
         aHeaders = null;
        foreach (request.getHeaders() as name:  someValues) {
             aHeaders ~= "%s: %s".format(name, join(", ",  someValues));
        }
       _contextOptions["header"] = join("\r\n",  aHeaders);
    }
    
    /**
     * Builds the request content based on the request object.
     *
     * If the request.body() is a string, it will be used as is.
     * Array data will be processed with {@link \UIM\Http\Client\FormData}
     * Params:
     * \Psr\Http\Message\IRequest request The request being sent.
     * @param Json[string] options Array of options to use.
     * /
    protected void _buildContent(IRequest request, Json[string] options = null) {
        body = request.getBody();
        body.rewind();
       _contextOptions["content"] = body.getContents();
    }
    
    /**
     * Build miscellaneous options for the request.
     * Params:
     * \Psr\Http\Message\IRequest request The request being sent.
     * @param Json[string] options Array of options to use.
     * /
    protected void _buildOptions(IRequest request, Json[string] options = null) {
       _contextOptions["method"] = request.getMethod();
       _contextOptions["protocol_version"] = request.getProtocolVersion();
       _contextOptions["ignore_errors"] = true;

        if (isSet(options["timeout"])) {
           _contextOptions["timeout"] = options["timeout"];
        }
        // Redirects are handled in the client layer because of cookie handling issues.
       _contextOptions["max_redirects"] = 0;

        if (isSet(options["proxy"]["proxy"])) {
           _contextOptions["request_fulluri"] = true;
           _contextOptions["proxy"] = options["proxy"]["proxy"];
        }
    }
    
    /**
     * Build SSL options for the request.
     * Params:
     * \Psr\Http\Message\IRequest request The request being sent.
     * @param Json[string] options Array of options to use.
     * /
    protected void _buildSslContext(IRequest request, Json[string] options = null) {
        sslOptions = [
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
            options["ssl_cafile"] = CaBundle.getBundledCaBundlePath();
        }
        if (!options.isEmpty("ssl_verify_host")) {
            url = request.getUri();
            host = parse_url((string)url, UIM_URL_HOST);
           _sslContextOptions["peer_name"] = host;
        }
        sslOptions.each!((key) {
            if (isSet(options[aKey])) {
                name = substr(aKey, 4);
               _sslContextOptions[name] = options[aKey];
            }
        });
    }
    
    /**
     * Open the stream and send the request.
     * Params:
     * \Psr\Http\Message\IRequest request The request object.
     * /
    // TODO protected Json[string] _send(IRequest request) {
        deadline = false;
        if (isSet(_contextOptions["timeout"]) && _contextOptions["timeout"] > 0) {
            /** @var int deadline * /
            deadline = time() + _contextOptions["timeout"];
        }
        url = request.getUri();
       _open(to!string(url, request));
        content = "";
        timedOut = false;

        assert(_stream !isNull, "HTTP stream failed to open");

        while (!feof(_stream)) {
            if (deadline != false) {
                stream_set_timeout(_stream, max(deadline - time(), 1));
            }
            content ~= fread(_stream, 8192);

            meta = stream_get_meta_data(_stream);
            if (meta["timed_out"] || (deadline != false && time() > deadline)) {
                timedOut = true;
                break;
            }
        }
        meta = stream_get_meta_data(_stream);
        /** @psalm-suppress InvalidPropertyAssignmentValue * /
        fclose(_stream);

        if (timedOut) {
            throw new DNetworkException("Connection timed out " ~ url, request);
        }
         aHeaders = meta["wrapper_data"];
        if (isSet(aHeaders["headers"]) && isArray(aHeaders["headers"])) {
             aHeaders = aHeaders["headers"];
        }
        return _createResponses(aHeaders, content);
    }
    
    /**
     * Build a response object
     * Params:
     * array  aHeaders Unparsed headers.
     * @param string abody The response body.
     * /
    protected DResponse _buildResponse(Json[string]  aHeaders, string abody) {
        return new DResponse(aHeaders, body);
    }
    
    /**
     * Open the socket and handle any connection errors.
     * Params:
     * string aurl The url to connect to.
     * @param \Psr\Http\Message\IRequest request The request object.
     * /
    protected void _open(string urlToConnect, IRequest request) {
        if (!(bool)ini_get("allow_url_fopen")) {
            throw new DClientException("The D directive `allow_url_fopen` must be enabled.");
        }

        bool set_error_handler(function (code, message) {
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
        }
    }
    
    /**
     * Get the context options
     *
     * Useful for debugging and testing context creation.
     * /
    Json[string] contextOptions() {
        return array_merge(_contextOptions, _sslContextOptions);
    } */
}
