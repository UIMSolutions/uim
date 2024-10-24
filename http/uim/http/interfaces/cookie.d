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
    int expiresTimestamp();

    // maxAge[get, set]long Maximum life time of the cookie 
    // rawValue[get, set] string Undecoded cookie payload 
    // secure[get, set]bool Require a secure connection for transmission of this cookie 
    // value[get, set] string Cookie payload
    // Sets the cookie name

    // Gets the cookie value
    string[] values();

    // Gets the cookie value as scalar.
    string value();

    // Builds the expiration value part of the header string
    string formattedExpires();

    /**
     * Check if a cookie is expired when compared to time
     * Cookies without an expiration date always return false. */
    // TODO bool isExpired(IDateTime time = null);

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
}
