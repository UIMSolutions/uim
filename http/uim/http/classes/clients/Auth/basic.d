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
    Request authentication(IRequest request, Json[string] credentials) {
        if (credentials.hasAllKeys("username", "password")) {
            auto headerValue = _generateHeader(credentials["username"], credentials["password"]);
            request = request.withHeader("Authorization", headerValue);
        }
        return request;
    }
    
    // Proxy Authentication
    Request proxyAuthentication(Request request, Json[string] credentials) {
        Request request;
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
