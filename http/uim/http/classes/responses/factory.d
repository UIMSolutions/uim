module uim.http.classes.responses.factory;

import uim.http;

@safe:

// Factory class for creating response instances.
class DResponseFactory : IResponseFactory {
    // Create a new response.
    IResponse createResponse(int httpStatusCode = 200, string reasonPhrase = "") {
        return (new DResponse()).withStatus(httpStatusCode, reasonPhrase);
    }
}
