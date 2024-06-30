module uim.http.classes.clients.auth.oauth;

import uim.http;

@safe:

/**
 * Oauth 1 authentication strategy for UIM\Http\Client
 *
 * This object does not handle getting Oauth access tokens from the service
 * provider. It only handles make client requests *after* you have obtained the Oauth
 * tokens.
 *
 * Generally not directly constructed, but instead used by {@link \UIM\Http\Client}
 * when options["auth.type"] is 'oauth'
 */
class DOauth {
    /**
     * Add headers for Oauth authorization.
     * Params:
     * \UIM\Http\Client\Request request The request object.
     * @param Json[string] credentials Authentication credentials.
     */
    Request authentication(Request request, Json[string] credentials) {
        if (!credentials.hasKey("consumerKey")) {
            return request;
        }
        if (credentials.isEmpty("method")) {
            credentials["method"] = "hmac-sha1";
        }
        credentials["method"] = credentials.getString("method").upper;

        switch (credentials["method"]) {
        case "HMAC-SHA1":
            bool hasKeys = credentials.hasKeys([
                "consumerSecret", "token", "tokenSecret"
            ]);
            if (!hasKeys) {
                return request;
            }
            aValue = _hmacSha1(request, credentials);
            break;

        case "RSA-SHA1":
            if (!credentials.hasKey("privateKey")) {
                return request;
            }
            aValue = _rsaSha1(request, credentials);
            break;

        case "PLAINTEXT":
            hasKeys = isSet(
                credentials["consumerSecret"],
                credentials["token"],
                credentials["tokenSecret"]
           );
            if (!hasKeys) {
                return request;
            }
            aValue = _plaintext(request, credentials);
            break;

        default:
            throw new DException(
                "Unknown Oauth signature method `%s`.".format(credentials["method"]));
        }
        return request.withHeader("Authorization", aValue);
    }

    /**
     * Plaintext signing
     *
     * This method is **not** suitable for plain HTTP.
     * You should only ever use PLAINTEXT when dealing with SSL
     * services.
     * Params:
     * \UIM\Http\Client\Request request The request object.
     */
    protected string _plaintext(Request request, Json[string] authCredentials) {
        auto someValues = [
            "oauth_version": "1.0",
            "oauth_nonce": uniqid(),
            "oauth_timestamp": time(),
            "oauth_signature_method": "PLAINTEXT",
            "oauth_token": authCredentials["token"],
            "oauth_consumer_key": authCredentials["consumerKey"],
        ];
        if (authCredentials.hasKey("realm")) {
            someValues["oauth_realm"] = authCredentials["realm"];
        }

        string[] keys = [
            authCredentials["consumerSecret"], authCredentials["tokenSecret"]
        ];
        string key = keys.join("&");
        someValues["oauth_signature"] = key;

        return _buildAuth(someValues);
    }

    /**
     * Use HMAC-SHA1 signing.
     * This method is suitable for plain HTTP or HTTPS.
     */
    protected string _hmacSha1(Request request, Json[string] authCredentials) {
        auto nonce = authCredentials["nonce"] ?  ? uniqid();
        auto timestamp = authCredentials["timestamp"] ?  ? time();
        someValues = [
            "oauth_version": "1.0",
            "oauth_nonce": nonce,
            "oauth_timestamp": timestamp,
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_token": authCredentials["token"],
            "oauth_consumer_key": _encode(authCredentials["consumerKey"]),
        ];
        baseString = this.baseString(request, someValues);

        // Consumer key should only be encoded for base string calculation as
        // auth header generation already encodes independently
        someValues["oauth_consumer_key"] = authCredentials["consumerKey"];

        if (authCredentials.hasKey("realm")) {
            someValues["oauth_realm"] = authCredentials["realm"];
        }
        string[] aKey = [
            authCredentials["consumerSecret"], authCredentials["tokenSecret"]
        ];
        aKey = array_map(_encode(...), aKey);
        aKey = aKey.join("&");

        someValues["oauth_signature"] = base64_encode(
            hash_hmac("sha1", baseString, aKey, true)
       );

        return _buildAuth(someValues);
    }

    /**
     * Use RSA-SHA1 signing.
     * This method is suitable for plain HTTP or HTTPS. */
    protected string _rsaSha1(Request request, Json[string] credentials) {
        if (!function_exists("openssl_pkey_get_private")) {
            throw new DException("RSA-SHA1 signature method requires the OpenSSL extension.");
        }
        nonce = credentials["nonce"] ?  ? bin2hex(Security.randomBytes(16));
        timestamp = credentials["timestamp"] ?  ? time();
        someValues = [
            "oauth_version": "1.0",
            "oauth_nonce": nonce,
            "oauth_timestamp": timestamp,
            "oauth_signature_method": "RSA-SHA1",
            "oauth_consumer_key": credentials["consumerKey"],
        ];
        if (credentials.hasKey("consumerSecret")) {
            someValues["oauth_consumer_secret"] = credentials["consumerSecret"];
        }
        if (credentials.hasKey("token")) {
            someValues["oauth_token"] = credentials["token"];
        }
        if (credentials.hasKey("tokenSecret")) {
            someValues["oauth_token_secret"] = credentials["tokenSecret"];
        }
        baseString = this.baseString(request, someValues);

        if (credentials.hasKey("realm")) {
            someValues["oauth_realm"] = credentials["realm"];
        }
        if (isResource(credentials["privateKey"])) {
            auto resource = credentials["privateKey"];
            auto privateKey = stream_get_contents(resource);
            rewind(resource);
            credentials["privateKey"] = privateKey;
        }
        credentials.merge([
                "privateKeyPassphrase": "",
            ]);
        if (isResource(credentials["privateKeyPassphrase"])) {
            auto resource = credentials["privateKeyPassphrase"];
            auto passphrase = stream_get_line(resource, 0, D_EOL);
            rewind(resource);
            credentials["privateKeyPassphrase"] = passphrase;
        }
        /** @var \OpenSSLAsymmetricKey|\OpenSSLCertificate|string[] aprivateKey */
        privateKey = openssl_pkey_get_private(credentials["privateKey"], credentials["privateKeyPassphrase"]);
        this.checkSslError();

        signature = "";
        openssl_sign(baseString, signature, privateKey);
        this.checkSslError();

        someValues["oauth_signature"] = base64_encode(signature);

        return _buildAuth(someValues);
    }

    /**
     * Generate the Oauth basestring
     *
     * - Querystring, request data and oauth_* parameters are combined.
     * - Values are sorted by name and then value.
     * - Request values are concatenated and urlencoded.
     * - The request URL (without querystring) is normalized.
     * - The HTTP method, URL and request parameters are concatenated and returned.
     */
    string baseString(Request request, Json[string] oauthData) {
        auto someParts = [
            request.getMethod(),
            _normalizedUrl(request.getUri()),
            _normalizedParams(request, oauthData),
        ];
        someParts = array_map(_encode(...), someParts);

        return join("&", someParts);
    }

    // Builds a normalized URL
    protected string _normalizedUrl(IUri anUri) {
        return anUri.getScheme() ~ ": //" ~ anUri.getHost().lower ~ anUri.getPath();
    }

    /**
     * Sorts and normalizes request data and oauthData
     *
     * Section 9.1.1 of Oauth spec.
     *
     * - URL encode keys + values.
     * - Sort keys & values by byte value.
     */
    protected string _normalizedParams(Request request, Json[string] oauthData) {
        auto aQuery = parse_url((string) request.getUri(), UIM_URL_QUERY);
        parse_str((string) aQuery, aQueryArgs);

        auto post = null;
        string contentType = request.getHeaderLine("Content-Type");
        if (contentType.isEmpty || contentType == "application/x-www-form-urlencoded") {
            parse_str(to!string(request.getBody()), post);
        }
        auto someArguments = chain(aQueryArgs, oauthData, post);
        auto pairs = _normalizeData(someArguments);
        auto someData = null;
        foreach (pairs as pair) {
            someData ~= join("=", pair);
        }
        sort(someData, SORT_STRING);

        return join("&", someData);
    }

    /**
     * Recursively convert request data into the normalized form.
     * Params:
     * Json[string] someArguments The arguments to normalize.
     * @param string aPath The current path being converted.
     */
    protected Json[string] _normalizeData(Json[string] someArguments, string aPath = null) {
        someData = null;
        someArguments.byKeyValue((kv) {
            if (somePath) {
                // Fold string keys with [].
                // Numeric keys result in a=b&a=c. While this isn`t
                // standard behavior in D, it is common in other platforms.
                if (!isNumeric(kv.key)) {
                    kv.key = "{somePath}[{kv.key}]";
                } else {
                    kv.key = somePath;
                }
            }
            if (isArray(kv.value)) {
                uksort(kv.value, "strcmp");
                someData = array_merge(someData, _normalizeData(kv.value, kv.key));
            } else {
                someData ~= [kv.key, kv.value];
            }
        });
        return someData;
    }

    // Builds the Oauth Authorization header value.
    protected string _buildAuth(Json[string] oauthData) {
        string result = "OAuth ";
        string[] params = someData.byKeyValue
            .map!(kv => kv.key ~ "=\"" ~ _encode((string) kv.value) ~ "\"").array;

        result ~= params.join(",");

        return result;
    }

    // URL Encodes a value based on rules of rfc3986
    protected string _encode(string valueToEncode) {
        return rawUrlEncode(valueToEncode).replace(["%7E", "+"], ["~", " "]);
    }

    // Check for SSL errors and throw an exception if found.
    protected void checkSslError() {
        string error = "";
        while (text = openssl_error_string()) {
            error ~= text;
        }
        if (error.length > 0) {
            throw new DException("openssl error: " ~ error);
        }
    }
}
