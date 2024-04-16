module uim.http.classes.requests.requestfactory;

import uim.http;

@safe:

// Factory for creating request instances.
class DRequestFactory { //} : IRequestFactory {
    /**
     * Create a new request.
     * Params:
     * string amethod The HTTP method associated with the request.
     * @param \Psr\Http\Message\IUri|string auri The URI associated with the request.
     * /

    IRequest createRequest(string amethod, anUri) {
        return new DRequest(anUri, method);
    } */
}
