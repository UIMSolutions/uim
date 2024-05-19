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
 * when options["auth"]["type"] is 'oauth'
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
                bool hasKeys = credentials.hasKeys(["consumerSecret", "token", "tokenSecret"]);
                if (!hasKeys) {
                    return request;
                }
                aValue = _hmacSha1(request, credentials);
                break;

            case "RSA-SHA1":
                if (!isSet(credentials["privateKey"])) {
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
                throw new UimException("Unknown Oauth signature method `%s`.".format(credentials["method"]));
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
     * @param Json[string] credentials Authentication credentials.
     */
    protected string _plaintext(Request request, Json[string] credentials) {
        auto someValues = [
            "oauth_version": "1.0",
            "oauth_nonce": uniqid(),
            "oauth_timestamp": time(),
            "oauth_signature_method": "PLAINTEXT",
            "oauth_token": credentials["token"],
            "oauth_consumer_key": credentials["consumerKey"],
        ];
        if (credentials.isSet("realm")) {
             someValues["oauth_realm"] = credentials["realm"];
        }
        
        string[] keys = [credentials["consumerSecret"], credentials["tokenSecret"]];
        string key = keys.join("&");
        someValues["oauth_signature"] = key;

        return _buildAuth(someValues);
    }
    
    /**
     * Use HMAC-SHA1 signing.
     *
     * This method is suitable for plain HTTP or HTTPS.
     * Params:
     * \UIM\Http\Client\Request request The request object.
     * @param Json[string] credentials Authentication credentials.
     */
    protected string _hmacSha1(Request request, Json[string] credentials) {
        auto nonce = credentials["nonce"] ?? uniqid();
        auto timestamp = credentials["timestamp"] ?? time();
         someValues = [
            "oauth_version": "1.0",
            "oauth_nonce": nonce,
            "oauth_timestamp": timestamp,
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_token": credentials["token"],
            "oauth_consumer_key": _encode(credentials["consumerKey"]),
        ];
        baseString = this.baseString(request,  someValues);

        // Consumer key should only be encoded for base string calculation as
        // auth header generation already encodes independently
         someValues["oauth_consumer_key"] = credentials["consumerKey"];

        if (isSet(credentials["realm"])) {
             someValues["oauth_realm"] = credentials["realm"];
        }
        string[] aKey = [credentials["consumerSecret"], credentials["tokenSecret"]];
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
            throw new UimException("RSA-SHA1 signature method requires the OpenSSL extension.");
        }
        nonce = credentials["nonce"] ?? bin2hex(Security.randomBytes(16));
        timestamp = credentials["timestamp"] ?? time();
         someValues = [
            "oauth_version": "1.0",
            "oauth_nonce": nonce,
            "oauth_timestamp": timestamp,
            "oauth_signature_method": "RSA-SHA1",
            "oauth_consumer_key": credentials["consumerKey"],
        ];
        if (isSet(credentials["consumerSecret"])) {
             someValues["oauth_consumer_secret"] = credentials["consumerSecret"];
        }
        if (isSet(credentials["token"])) {
             someValues["oauth_token"] = credentials["token"];
        }
        if (isSet(credentials["tokenSecret"])) {
             someValues["oauth_token_secret"] = credentials["tokenSecret"];
        }
        baseString = this.baseString(request,  someValues);

        if (isSet(credentials["realm"])) {
             someValues["oauth_realm"] = credentials["realm"];
        }
        if (isResource(credentials["privateKey"])) {
            resource = credentials["privateKey"];
            privateKey = stream_get_contents(resource);
            rewind(resource);
            credentials["privateKey"] = privateKey;
        }
        credentials += [
            'privateKeyPassphrase": "",
        ];
        if (isResource(credentials["privateKeyPassphrase"])) {
            resource = credentials["privateKeyPassphrase"];
            passphrase = stream_get_line(resource, 0, D_EOL);
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
     * Params:
     * \UIM\Http\Client\Request request The request object.
     * @param Json[string] oauthValues Oauth values.
     */
    string baseString(Request request, Json[string] oauthValues) {
        auto someParts = [
            request.getMethod(),
           _normalizedUrl(request.getUri()),
           _normalizedParams(request, oauthValues),
        ];
        someParts = array_map(_encode(...), someParts);

        return join("&", someParts);
    }
    
    // Builds a normalized URL
    protected string _normalizedUrl(IUri anUri) {
        return anUri.getScheme() ~ "://" ~ anUri.getHost().lower ~ anUri.getPath();
    }
    
    /**
     * Sorts and normalizes request data and oauthValues
     *
     * Section 9.1.1 of Oauth spec.
     *
     * - URL encode keys + values.
     * - Sort keys & values by byte value.
     * Params:
     * \UIM\Http\Client\Request request The request object.
     * @param Json[string] oauthValues Oauth values.
     */
    protected string _normalizedParams(Request request, Json[string] oauthValues) {
        aQuery = parse_url((string)request.getUri(), UIM_URL_QUERY);
        parse_str((string)aQuery, aQueryArgs);

        post = null;
        string contentType = request.getHeaderLine("Content-Type");
        if (contentType.isEmpty || contentType == "application/x-www-form-urlencoded") {
            parse_str(to!string(request.getBody()), post);
        }
        someArguments = chain(aQueryArgs, oauthValues, post);
        pairs = _normalizeData(someArguments);
        someData = null;
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
    protected Json[string] _normalizeData(Json[string] someArguments, string aPath= null) {
        someData = null;
        foreach (someArguments as aKey: aValue) {
            if (somePath) {
                // Fold string keys with [].
                // Numeric keys result in a=b&a=c. While this isn`t
                // standard behavior in D, it is common in other platforms.
                if (!isNumeric(aKey)) {
                    aKey = "{somePath}[{aKey}]";
                } else {
                    aKey = somePath;
                }
            }
            if (isArray(aValue)) {
                uksort(aValue, "strcmp");
                someData = array_merge(someData, _normalizeData(aValue, aKey));
            } else {
                someData ~= [aKey, aValue];
            }
        }
        return someData;
    }
    
    // Builds the Oauth Authorization header value.
    protected string _buildAuth(Json[string] oauthValues) {
        string result = "OAuth ";
        string[] params = someData.byKeyValue
            .map!(kv => kv.key ~ "=\"" ~ _encode((string)kv.value) ~ "\"").array;

         result ~= params.join(",");

        return result;
    }
    
    // URL Encodes a value based on rules of rfc3986
    protected string _encode(string valueToEncode) {
        return rawurlencode(valueToEncode).replace(["%7E", "+"], ["~", " "]);
    }
    
    // Check for SSL errors and throw an exception if found.
    protected void checkSslError() {
        string error = "";
        while (text = openssl_error_string()) {
            error ~= text;
        }
        if (error.length > 0) {
            throw new UimException("openssl error: " ~ error);
        }
    }
}
