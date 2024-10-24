/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.clients.auth.basic;

import uim.http;

@safe:

/*/**
 * Basic authentication adapter for UIM\Http\Client
 *
 * Generally not directly constructed, but instead used by {@link \UIM\Http\Client}
 * when options.get("auth.type"] is 'basic'
 */
class DBasic {
    // Add Authorization header to the request.
    IRequest authentication(IRequest request, Json[string] credentials) {
        if (credentials.hasAllKeys("username", "password")) {
            auto headerValue = _generateHeader(credentials["username"], credentials["password"]);
            request = request.withHeader("Authorization", headerValue);
        }
        return request;
    }
    
    // Proxy Authentication
    IRequest proxyAuthentication(IRequest request, Json[string] credentials) {
        IRequest request;
        if (credentials.hasAllKeys("username", credentials["password"])) {
            auto aValue = _generateHeader(credentials["username"], credentials["password"]);
            auto request = request.withHeader("Proxy-Authorization", aValue);
        }
        return request;
    }
    
    // Generate basic [proxy] authentication header
    protected string _generateHeader(string username, string password) {
        return "Basic " ~ base64_encode(username ~ ": " ~ password);
    }
}
