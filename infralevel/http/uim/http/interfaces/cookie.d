/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.interfaces.cookie;

import uim.http;

@safe:

// Cookie Interface
interface ICookie : IObject {
    // Get the id for a cookie
    /* string id();

    // The path / local URI for which the cookie is valid
    string path();

    // Get the domain attribute.
    string domain();

    // Expiration date of the cookie
    long expiresTimestamp();
    string expiresString();
    DateTime expiresDateTime();

    // Check if a cookie is expired when compared to time
    bool isExpired();
    bool isExpired(long time);
    bool isExpired(DateTime time);
    bool isExpired(string time);

    // Gets the cookie values
    string[] values();

    // Gets the cookie value as scalar.
    string value();

    // Check if the cookie is HTTP only
    bool isHttpOnly();

    // Get the SameSite attribute.
    SAMESITE sameSite();

    // Get cookie options
    Json[string] options();

    // Get cookie data as array.
    Json[string] toArray();

    // Returns the cookie as header value
    string toHeaderValue();

    // Check if the cookie is secure
    bool isSecure();

    ICookie clone(); */
}
