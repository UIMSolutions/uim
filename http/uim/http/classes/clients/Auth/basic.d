module uim.http.classes.clients.auth.basic;

import uim.http;

@safe:

/* /**
 * Basic authentication adapter for UIM\Http\Client
 *
 * Generally not directly constructed, but instead used by {@link \UIM\Http\Client}
 * when options["auth"]["type"] is 'basic'
 */
class DBasic {
    /**
     * Add Authorization header to the request.
     * Params:
     * \UIM\Http\Client\Request request Request instance.
     * @param array credentials Credentials.
     * /
    Request authentication(Request request, array credentials) {
        if (isSet(credentials["username"], credentials["password"])) {
            aValue = _generateHeader(credentials["username"], credentials["password"]);
            request = request.withHeader("Authorization", aValue);
        }
        return request;
    }
    
    /**
     * Proxy Authentication
     * Params:
     * \UIM\Http\Client\Request request Request instance.
     * @param array credentials Credentials.
     * /
    Request proxyAuthentication(Request request, array credentials) {
        if (isSet(credentials["username"], credentials["password"])) {
            aValue = _generateHeader(credentials["username"], credentials["password"]);
            request = request.withHeader("Proxy-Authorization", aValue);
        }
        return request;
    }
    
    /**
     * Generate basic [proxy] authentication header
     * Params:
     * string auser Username.
     * @param string apass Password.
     * /
    protected string _generateHeader(string auser, string apass) {
        return "Basic " ~ base64_encode(user ~ ":" ~ pass);
    } */
}
