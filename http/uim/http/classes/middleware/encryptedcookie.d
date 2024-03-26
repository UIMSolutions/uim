module uim.http.classes.middleware.encryptedcookie;

import uim.http;

@safe:

/**
 * Middleware for encrypting & decrypting cookies.
 *
 * This middleware layer will encrypt/decrypt the named cookies with the given key
 * and cipher type. To support multiple keys/cipher types use this middleware multiple
 * times.
 *
 * Cookies in request data will be decrypted, while cookies in response headers will
 * be encrypted automatically. If the response is a {@link \UIM\Http\Response}, the cookie
 * data set with `withCookie()` and `cookie()`` will also be encrypted.
 *
 * The encryption types and padding are compatible with those used by CookieComponent
 * for backwards compatibility.
 */
class EncryptedCookieMiddleware {
    /*
}: IMiddleware {
    use CookieCryptTemplate();

    // The list of cookies to encrypt/decrypt
    protected string[] cookieNames;

    // Encryption key to use.
    protected string aKey;

    // Encryption type.
    protected string acipherType;

    /**
     * Constructor
     * Params:
     * string[] cookieNames The list of cookie names that should have their values encrypted.
     * @param string aKey The encryption key to use.
     * @param string acipherType The cipher type to use. Defaults to 'aes'.
     * /
    this(array cookieNames, string aKey, string acipherType = "aes") {
        this.cookieNames = cookieNames;
        this.key = aKey;
        this.cipherType = cipherType;
    }
    
    /**
     * Apply cookie encryption/decryption.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request.
     * @param \Psr\Http\Server\IRequestHandler handler The request handler.
     * /
    IResponse process(IServerRequest serverRequest, IRequestHandler handler) {
        if (serverRequest.getCookieParams()) {
            serverRequest = this.decodeCookies(serverRequest);
        }
        response = handler.handle(serverRequest);
        if (response.hasHeader("Set-Cookie")) {
            response = this.encodeSetCookieHeader(response);
        }
        if (cast(Response)response) {
            response = this.encodeCookies(response);
        }
        return response;
    }
    
    /**
     * Fetch the cookie encryption key.
     *
     * Part of the CookieCryptTrait implementation.
     * /
    protected string _getCookieEncryptionKey() {
        return this.key;
    }
    
    /**
     * Decode cookies from the request.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request to decode cookies from.
     * /
    protected IServerRequest decodeCookies(IServerRequest serverRequest) {
        cookies = serverRequest.getCookieParams();
        this.cookieNames
            .filter!(cookieName => isSet(cookies[cookieName]))
            .each!(cookieName => cookies[cookieName] = _decrypt(cookies[cookieName], this.cipherType, this.key));

        return serverRequest.withCookieParams(cookies);
    }
    
    /**
     * Encode cookies from a response`s CookieCollection.
     * Params:
     * \UIM\Http\Response response The response to encode cookies in.
     * /
    protected Response encodeCookies(Response response) {
        response.getCookieCollection()
            .filter!(cookie => in_array(cookie.name, this.cookieNames, true))
            .each!((cookie) {
                aValue = _encrypt(cookie.getValue(), this.cipherType);
                response = response.withCookie(cookie.withValue(aValue));
            });

        return response;
    }
    
    // Encode cookies from a response`s Set-Cookie header
    protected IResponse encodeSetCookieHeader(IResponse response) {
        auto aHeader = [];
        auto cookies = CookieCollection.createFromHeader(response.getHeader("Set-Cookie"));
        cookies.each!((cookie) {
            if (in_array(cookie.name, this.cookieNames, true)) {
                auto value = _encrypt(cookie.getValue(), this.cipherType);
                auto cookieWithValue = cookie.withValue(value);
            }
            aHeader ~= cookieWithValue.toHeaderValue();
        });
        return response.withHeader("Set-Cookie",  aHeader);
    } */
}
