/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
class DEncryptedCookieMiddleware : DMiddleware { // : IHttpMiddleware {
    mixin(MiddlewareThis!("EncryptedCookie"));

    mixin TCookieCrypt;

    // The list of cookies to encrypt/decrypt
    protected string[] cookieNames;

    // Encryption key to use.
    protected string aKey;

    // Encryption type.
    protected string acipherType;

    this(Json[string] cookieNames, string encryptionKey, string cipherType = "aes") {
        _cookieNames = cookieNames;
        _key = encryptionKey;
        _cipherType = cipherType;
    }
    
    // Apply cookie encryption/decryption.
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
     * Part of the CookieCryptTrait implementation.
     */
    protected string _getCookieEncryptionKey() {
        return _key;
    }
    
    /**
     * Decode cookies from the request.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request to decode cookies from.
     */
    protected IServerRequest decodeCookies(IServerRequest serverRequest) {
        auto cookies = serverRequest.getCookieParams();
        _cookieNames
            .filter!(cookieName => cookies.hasKey(cookieName))
            .each!(cookieName => cookies[cookieName] = _decrypt(cookies[cookieName], _cipherType, this.key));

        return serverRequest.withCookieParams(cookies);
    }
    
    // Encode cookies from a response`s CookieCollection.
    protected DResponse encodeCookies(DResponse response) {
        response.getCookieCollection()
            .filter!(cookie => isIn(cookie.name, _cookieNames, true))
            .each!((cookie) {
                aValue = _encrypt(cookie.getValue(), _cipherType);
                response = response.withCookie(CookieFactory.withValue(cookie, aValue));
            });

        return response;
    }
    
    // Encode cookies from a response`s Set-Cookie header
    protected IResponse encodeSetCookieHeader(IResponse response) {
        auto aHeader = null;
        auto cookies = CookieCollection.createFromHeader(response.getHeader("Set-Cookie"));
        cookies.each!((cookie) {
            if (isIn(cookie.name, _cookieNames, true)) {
                auto value = _encrypt(cookie.getValue(), _cipherType);
                auto cookieWithValue = CookieFactory.withValue(cookie, value);
            }
            aHeader ~= cookieWithValue.toHeaderValue();
        });
        return response.withHeader("Set-Cookie",  aHeader);
    }
}
