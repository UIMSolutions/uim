/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
 * when options.get("auth.type"] is 'oauth'
 */
class DOauth {
    // Add headers for Oauth authorization.
    Request authentication(DRequest request, Json[string] authCredentials) {
        if (!authCredentials.hasKey("consumerKey")) {
            return request;
        }
        authCredentials.set("method", authCredentials.isEmpty("method")
                ? "hmac-sha1" : authCredentials.getString("method").upper);

        switch (authCredentials.getString("method")) {
        case "HMAC-SHA1":
            bool hasKeys = authCredentials.hasKeys([
                "consumerSecret", "token", "tokenSecret"
            ]);
            if (!hasKeys) {
                return request;
            }
            aValue = _hmacSha1(request, authCredentials);
            break;

        case "RSA-SHA1":
            if (!authCredentials.hasKey("privateKey")) {
                return request;
            }
            aValue = _rsaSha1(request, authCredentials);
            break;

        case "PLAINTEXT":
            hasKeys = isSet(
                authCredentials["consumerSecret"],
                authCredentials["token"],
                authCredentials["tokenSecret"]
            );
            if (!hasKeys) {
                return request;
            }
            aValue = _plaintext(request, authCredentials);
            break;

        default:
            throw new UIMException(
                "Unknown Oauth signature method `%s`.".format(
                    authCredentials["method"]));
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
            "oauth_token": authCredentials.get("token"),
            "oauth_consumer_key": authCredentials.get("consumerKey"),
        ];
        if (authCredentials.hasKey("realm")) {
            someValues.set("oauth_realm", authCredentials.get("realm"));
        }

        string[] keys = [
            authCredentials["consumerSecret"], authCredentials.get("tokenSecret")
        ];
        string key = keys.join("&");
        someValues.set("oauth_signature", key);

        return _buildAuth(someValues);
    }

    /**
     * Use HMAC-SHA1 signing.
     * This method is suitable for plain HTTP or HTTPS.
     */
    protected string _hmacSha1(Request request, Json[string] authCredentials) {
        auto nonce = authCredentials.get("nonce", uniqid());
        auto timestamp = authCredentials.get("timestamp", time());
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
        someValues.set("oauth_consumer_key", authCredentials["consumerKey"]);

        if (authCredentials.hasKey("realm")) {
            someValues.set("oauth_realm", authCredentials["realm"]);
        }
        string[] key = [
            authCredentials.getString("consumerSecret"),
            authCredentials.getString("tokenSecret")
        ];
        // key = array_map(_encode(...), key);
        key = key.join("&");

        someValues.set("oauth_signature", base64_encode(
                hash_hmac("sha1", baseString, key, true)
        ));

        return _buildAuth(someValues);
    }

    /**
     * Use RSA-SHA1 signing.
     * This method is suitable for plain HTTP or HTTPS. */
    protected string _rsaSha1(Request request, Json[string] authCredentials) {
        if (!function_hasKey("openssl_pkey_get_private")) {
            throw new UIMException("RSA-SHA1 signature method requires the OpenSSL extension.");
        }
        auto nonce = authCredentials.get("nonce", bin2hex(Security.randomBytes(16)));
        auto timestamp = authCredentials.get("timestamp", time());
        auto someValues = [
            "oauth_version": "1.0",
            "oauth_nonce": nonce,
            "oauth_timestamp": timestamp,
            "oauth_signature_method": "RSA-SHA1",
            "oauth_consumer_key": authCredentials["consumerKey"],
        ];
        if (authCredentials.hasKey("consumerSecret")) {
            someValues.set("oauth_consumer_secret", authCredentials["consumerSecret"]);
        }
        if (authCredentials.hasKey("token")) {
            someValues.set("oauth_token", authCredentials["token"]);
        }
        if (authCredentials.hasKey("tokenSecret")) {
            someValues.set("oauth_token_secret", authCredentials["tokenSecret"]);
        }

        auto baseString = this.baseString(request, someValues);
        if (authCredentials.hasKey("realm")) {
            someValues.set("oauth_realm", authCredentials["realm"]);
        }
        if (isResource(authCredentials.get("privateKey"))) {
            auto resource = authCredentials.get("privateKey");
            auto privateKey = stream_get_contents(resource);
            rewind(resource);
            authCredentials.set("privateKey", privateKey);
        }
        authCredentials.merge("privateKeyPassphrase", "");

        if (isResource(authCredentials["privateKeyPassphrase"])) {
            auto resource = authCredentials["privateKeyPassphrase"];
            auto passphrase = stream_get_line(resource, 0, D_EOL);
            rewind(resource);
            authCredentials.set("privateKeyPassphrase", passphrase);
        }
        /** @var \OpenSSLAsymmetricKey|\OpenSSLCertificate|string[] aprivateKey */
        auto privateKey = openssl_pkey_get_private(authCredentials["privateKey"], authCredentials["privateKeyPassphrase"]);
        this.checkSslError();

        auto signature = "";
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
        // someParts = array_map(_encode(...), someParts);

        return join("&", someParts);
    }

    // Builds a normalized URL
    protected string _normalizedUrl(IUri anUri) {
        return anUri.getScheme() ~ ": //" ~ anUri.getHost().lower ~ anUri.path();
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
        auto aQuery = parse_url( /* (string)  */ request.getUri(), UIM_URL_QUERY);
        // parse_str((string) aQuery, aQueryArgs);

        auto post = null;
        string contentType = request.getHeaderLine("Content-Type");
        if (contentType.isEmpty || contentType == "application/x-www-form-urlencoded") {
            // parse_str(to!string(request.getBody()), post);
        }
        auto arguments = chain(aQueryArgs, oauthData, post);
        auto pairs = _normalizeData(arguments);
        auto someData = null;
        foreach (pair; pairs) {
            someData ~= pair.join("=");
        }
        sort(someData, SORT_STRING);

        return join("&", someData);
    }

    // Recursively convert request data into the normalized form.
    protected Json[string] _normalizeData(Json[string] arguments, string convertedPath = null) {
        auto someData = null;
        arguments.byKeyValue((kv) {
            if (convertedPath) {
                // Fold string keys with [].
                // Numeric keys result in a=b&a=c. While this isn`t
                // standard behavior in D, it is common in other platforms.
                kv.key = !isNumeric(kv.key)
                    ? "{convertedPath}[{kv.key}]" : convertedPath;
            }
            if (kv.value.isArray) {
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
            .map!(kv => kv.key ~ "=\"" ~ _encode( /* (string)  */ kv.value) ~ "\"").array;

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
            throw new UIMException("openssl error: " ~ error);
        }
    }
}
