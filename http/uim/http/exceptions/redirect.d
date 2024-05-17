module uim.http.exceptions.redirect;

import uim.http;

@safe:

/*
 * An exception subclass used by routing and application code to
 * trigger a redirect.
 *
 * The URL and status code are provided as constructor arguments.
 *
 * ```
 * throw new DRedirectException("http://example.com/some/path", 301);
 * ```
 *
 * Additional headers can also be provided in the constructor, or
 * using the headers() method.
 */
class DRedirectException : DHttpException {
    /**
     * Constructor
     * Params:
     * headerToSend - The headers that should be sent in the unauthorized challenge response.
     */
    this(string redirectUrl, int statusCode = 302, Json[string] headerToSend = null) {
        super(redirectUrl, statusCode);

        headerToSend.byKeyValue
            .each!(kv => this.header(kv.key, kv.value));
    } */
}
