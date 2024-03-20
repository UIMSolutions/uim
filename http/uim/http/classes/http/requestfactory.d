module uim.cake.http;

import uim.cake;

@safe:

// Factory for creating request instances.
class RequestFactory : IRequestFactory {
    /**
     * Create a new request.
     * Params:
     * string amethod The HTTP method associated with the request.
     * @param \Psr\Http\Message\IUri|string auri The URI associated with the request.
     */



    IRequest createRequest(string amethod, anUri) {
        return new Request(anUri, method);
    }
}
