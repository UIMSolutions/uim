/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.adapters.mock;

import uim.http;

@safe:

/**
 * : sending requests to an array of stubbed responses
 *
 * This adapter is not intended for production use. Instead
 * it is the backend used by `Client.addMockResponse()`
 *
 * @internal
 */
class DMockAdapter { //}: IAdapter {
    // List of mocked responses.
    protected Json[string] _responses = null;

    /**
     * Add a mocked response.
     *
     * ### Options
     *
     * - `match` An additional closure to match requests with.
     */
    void addResponse(IRequest requestForMatch, DResponse response, Json[string] options = null) {
        if (options.hasKey("match") /* && !(cast(IClosure)options.get("match") */) {
            /* auto type = get_debug_type(options.get("match"));
            throw new DInvalidArgumentException(
                "The `match` option must be a `Closure`. Got `%s`."
                .format(type
           )); */
        }
        /* _responses ~= [
            "request": requestForMatch,
            "response": response,
            "options": options,
        ]; */
    }
    
    // Find a response if one exists.
    IResponse[] send(IRequest requestToMatch, Json[string] options = null) {
        auto found = null;
        auto method = requestToMatch.getMethod();
        // auto requestUri = to!string(requestToMatch.getUri());

        size_t foundIndex = -1;
        foreach (index, mock; _responses) {
            /* if (method != mock["request"].getMethod()) {
                continue;
            }
            if (!urlMatches(requestUri, mock["request"])) {
                continue;
            } */
            if (mock.hasKey("options.match")) {
                /* match = mock["options.match"](request);
                if (!isBoolean(match)) {
                    throw new DInvalidArgumentException("Match callback must return a boolean value.");
                }
                if (!match) {
                    continue;
                } */
            }
            // foundIndex = index;
            break;
        }
        if (foundIndex >= 0) {
            // Move the current mock to the end so that when there are multiple
            // matches for a URL the next match is used on subsequent requests.
            // auto mock = _responses[foundIndex];
            /* _responses.removeKey(foundIndex);
            _responses ~= mock; */

            return null; // [mock["response"]];
        }
        // throw new DMissingResponseException(["method": method, "url": requestUri]);
         return null;
    }
    
    // Check if the request URI matches the mock URI.
    protected bool urlMatches(string sentRequestUri, IRequest requestToMock) {
        /* string mockUri = (string)mock.getUri();
        if (sentRequestUri == mockUri) {
            return true;
        }
        size_t starPosition = mockUri.indexOf("/%2A");
        if (starPosition == mockUri.length - 4) {
            mockUri = mockUri[0..starPosition];

            return sentRequestUri.startsWith(mockUri);
        } */
        return false;
    }
}
