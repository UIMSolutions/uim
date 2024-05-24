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
    /*alias Alias = ;
    // List of mocked responses.
    protected Json[string] responses = null;

    /**
     * Add a mocked response.
     *
     * ### Options
     *
     * - `match` An additional closure to match requests with.
     */
    void addResponse(IRequest requestForMatch, Response response, Json[string] options = null) {
        if (isSet(options["match"]) && !(cast(DClosure)options["match"])) {
            type = get_debug_type(options["match"]);
            throw new DInvalidArgumentException(
                "The `match` option must be a `Closure`. Got `%s`."
                .format(type
            ));
        }
        this.responses ~= [
            "request": requestForMatch,
            "response": response,
            "options": options,
        ];
    }
    
    // Find a response if one exists.
    Response[] send(IRequest requestToMatch, Json[string] options = null) {
        auto found = null;
        auto method = requestToMatch.getMethod();
        auto requestUri = to!string(requestToMatch.getUri());

        foreach (anIndex: mock; this.responses) {
            if (method != mock["request"].getMethod()) {
                continue;
            }
            if (!this.urlMatches(requestUri, mock["request"])) {
                continue;
            }
            if (isSet(mock["options"]["match"])) {
                match = mock["options"]["match"](request);
                if (!isBool(match)) {
                    throw new DInvalidArgumentException("Match callback must return a boolean value.");
                }
                if (!match) {
                    continue;
                }
            }
            found = anIndex;
            break;
        }
        if (!found.isNull) {
            // Move the current mock to the end so that when there are multiple
            // matches for a URL the next match is used on subsequent requests.
            mock = this.responses[found];
            unset(this.responses[found]);
            this.responses ~= mock;

            return [mock["response"]];
        }
        throw new DMissingResponseException(["method": method, "url": requestUri]);
    }
    
    // Check if the request URI matches the mock URI.
    protected bool urlMatches(string sentRequestUri, IRequest requestToMock) {
        string mockUri = (string)mock.getUri();
        if (sentRequestUri == mockUri) {
            return true;
        }
        size_t starPosition = mockUri.indexOf("/%2A");
        if (starPosition == mockUri.length - 4) {
            mockUri = mockUri[0..starPosition];

            return sentRequestUri.startWith(mockUri);
        }
        return false;
    }
}
