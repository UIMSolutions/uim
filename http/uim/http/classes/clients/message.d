module uim.http.classes.clients.message;

import uim.http;

@safe:

/**
 * Base class for other HTTP requests/responses
 *
 * Defines some common helper methods, constants
 * and properties.
 */
class DMessage {
    // HTTP 200 code
    const int STATUS_OK = 200;

    /**
     * HTTP 201 code
     */
    const int STATUS_CREATED = 201;

    /**
     * HTTP 202 code
     */
    const int STATUS_ACCEPTED = 202;

    /**
     * HTTP 203 code
     */
    const int STATUS_NON_AUTHORITATIVE_INFORMATION = 203;

    /**
     * HTTP 204 code
     */
    const int STATUS_NO_CONTENT = 204;

    /**
     * HTTP 301 code
     */
    const int STATUS_MOVED_PERMANENTLY = 301;

    /**
     * HTTP 302 code
     */
    const int STATUS_FOUND = 302;

    /**
     * HTTP 303 code
     */
    const int STATUS_SEE_OTHER = 303;

    /**
     * HTTP 307 code
     */
    const int STATUS_TEMPORARY_REDIRECT = 307;

    /**
     * HTTP 308 code
     */
    const int STATUS_PERMANENT_REDIRECT = 308;

    /**
     * HTTP GET method
     */
    const string METHOD_GET = "GET";

    /**
     * HTTP POST method
     */
    const string METHOD_POST = "POST";

    /**
     * HTTP PUT method
     */
    const string METHOD_PUT = "PUT";

    /**
     * HTTP DELETE method
     */
    const string METHOD_DELETE = "DELETE";

    // HTTP PATCH method
    const string METHOD_PATCH = "PATCH";

    /**
     * HTTP OPTIONS method
     */
    const string METHOD_OPTIONS = "OPTIONS";

    /**
     * HTTP TRACE method
     */
    const string METHOD_TRACE = "TRACE";

    /**
     * HTTP HEAD method
     */
    const string METHOD_HEAD = "HEAD";

    /**
     * The array of cookies in the response.
     *
     * @var array
     * /
    // TODO protected array Json[string] _cookies = null;

    /**
     * Get all cookies
     *
     * /
    array cookies() {
        return _cookies;
    } */
}
