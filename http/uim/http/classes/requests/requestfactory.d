module uim.http.classes.requests.requestfactory;

import uim.http;

@safe:

// Factory for creating request instances.
class DRequestFactory { //} : IRequestFactory {
    // Create a new request.
    IRequest createRequest(string httpMethod, string requestUri) {
        return new DRequest(requestUri, httpMethod);
    }
}
