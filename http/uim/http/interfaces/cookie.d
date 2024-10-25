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

    // Get the domain attribute.
    string domain();

    // Expiration date of the cookie
    int expiresTimestamp();

    string expiresString();
    DateTime expiresDateTime();

    // Get the current expiry time
    DateTime expires();

    // Get the timestamp from the expiration time
    int expiresTimestamp();

    // Gets the cookie value
    string[] values();

    // Gets the cookie value as scalar.
    string value();

    // Builds the expiration value part of the header string
    string formattedExpires();

    /**
     * Check if a cookie is expired when compared to time
     * Cookies without an expiration date always return false. */
    bool isExpired();
    bool isExpired(DateTime time);

    // Check if the cookie is HTTP only
    bool isHttpOnly();

    // Get the SameSite attribute.
    SameSiteEnum getSameSite();

    // Get cookie options
    Json[string] options();

    // Get cookie data as array.
    Json[string] toArray();

    // Returns the cookie as header value
    string toHeaderValue();

    // Check if the cookie is secure
    bool isSecure();
}
