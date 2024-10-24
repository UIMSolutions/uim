/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.interfaces.cookie;

import uim.http;

@safe:

// Cookie Interface
interface ICookie : INamed {
    // Get the id for a cookie
    string id();

    // The path / local URI for which the cookie is valid
    string path();
    void path(string value);

    // Get the domain attribute.
    void domain(string name);
    string domain();

    // Expiration date of the cookie
    string expires();
    void expires(string datetime);
    // Get the current expiry time
    //    IDateTime expires();
    // Get the timestamp from the expiration time
    int getExpiresTimestamp();

    // maxAge[get, set]long Maximum life time of the cookie 
    // rawValue[get, set] string Undecoded cookie payload 
    // secure[get, set]bool Require a secure connection for transmission of this cookie 
    // value[get, set] string Cookie payload
    // Sets the cookie name
    static void withName(string aName);

    // Gets the cookie value
    string[] values();

    // Gets the cookie value as scalar.
    string value();

    // Create a cookie with an updated value.
    static withValue(string[]/* |float|bool */
        aValue);

    // Create a new cookie with an updated path
    static auto withPath(string aPath);

    // Create a cookie with an updated domain
    static auto withDomain(string domainName);

    // Builds the expiration value part of the header string
    string getFormattedExpires();

    /**
     * Check if a cookie is expired when compared to time
     * Cookies without an expiration date always return false. */
    bool isExpired(IDateTime time = null);

    // Check if the cookie is HTTP only
    void isHttpOnly(bool mode);
    bool isHttpOnly();

    // Get the SameSite attribute.
    // TODO SameSiteEnum getSameSite();
    // sameSite[get, set] Cookie.SameSite Prevent cross - site request forgery.

    // Get cookie options
    Json[string] options();

    // Get cookie data as array.
    Json[string] toArray();

    // Returns the cookie as header value
    string toHeaderValue();

    // Check if the cookie is secure
    bool isSecure();

    // #region cookie creation
    // Create a cookie with an updated expiration date
    static auto withExpiry(IDateTime dateTime);

    // Create a new cookie that will virtually never expire.
    static auto withNeverExpire();

    // Create a new cookie that will expire/delete the cookie from the browser.
    static auto withExpired();

    // Create a cookie with HTTP Only updated
    static void withHttpOnly(bool httpOnly);

    // Create a cookie with Secure updated
    static void withSecure(bool secure);

    // Create a cookie with an updated SameSite option.
    static auto withSameSite( /* SameSiteEnum| */ string sameSite);
    // #endregion cookie creation
}
