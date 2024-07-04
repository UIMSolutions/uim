module uim.http.classes.corsbuilder;

import uim.http;

@safe:

/**
 * A builder object that assists in defining Cross Origin Request related
 * headers.
 *
 * Each of the methods in this object provide a fluent interface. Once you've
 * set all the headers you want to use, the `build()` method can be used to return
 * a modified Response.
 *
 * It is most convenient to get this object via `Response.cors()`.
 */
class DCorsBuilder {
    // The response object this builder is attached to.
    protected IResponse _response;

    // The request`s Origin header value
    protected string _origin;

    // Whether the request was over SSL.
    protected bool _isSsl;

    // The headers that have been queued so far.
    protected Json[string] _headers = null;

    this(IResponse aResponse, string originHeader, bool isRequestOverSsl = false) {
       _origin = originHeader;
       _isSsl = isRequestOverSsl;
       _response = aResponse;
    }
    
    /**
     * Apply the queued headers to the response.
     *
     * If the builder has no Origin, or if there are no allowed domains,
     * or if the allowed domains do not match the Origin header no headers will be applied.
     */
    IResponse build() {
        auto response = _response;
        if (_origin.isEmpty) {
            return response;
        }
        if (isSet(_headers.hasKey(["Access-Control-Allow-Origin"])) {
            _headers.byKeyValue
                .each!(kv => response.withHeader(kv.key, kv.value));
        }
        return response;
    }
    
    /**
     * Set the list of allowed domains.
     *
     * Accepts a string or an array of domains that have CORS enabled.
     * You can use `*.example.com` wildcards to accept subdomains, or `*` to allow all domains
     * Params:
     * string[]|string adomains The allowed domains
     */
    void allowOrigin(string[] allowedDomains) {
        auto normalizeDomains = _normalizeDomains(/* (array) */allowedDomains);
        foreach (domain; normalizeDomains) {
            if (!preg_match(domain["preg"], _origin)) {
                continue;
            }
            aValue = domain["original"] == "*" ? "*" : _origin;
           _headers["Access-Control-Allow-Origin"] = aValue;
            break;
        }
    }
    
    // Normalize the origin to regular expressions and put in an array format
    protected Json[string] _normalizeDomains(string[] domainNamesToNormalize) {
        auto result;
        foreach (domainName; domainNamesToNormalize) {
            if (domainName == "*") {
                result ~= ["preg": "@.@", "original": "*"];
                continue;
            }
            result ~= normalizeDomain(domainName);
        }
        return result;
    }

protected Json[string] normalizeDomain(string domainName) {
    string result;
    auto original = domainName;
    string preg = domainName;
    if (!domainName.contains(": //")) {
        preg = (_isSsl ? "https://' : 'http://") ~ domainName;
    }
    preg = "@^" ~ preg_quote(preg, "@").replace("\*", ".*") ~ "@";
    return ["original": original, "preg": preg].toJsonMap;
}
    
    /**
     * Set the list of allowed HTTP Methods.
     * allowedMethods - The allowed HTTP methods
     */
    void allowMethods(string[] allowedMethods) {
       _headers["Access-Control-Allow-Methods"] = allowedMethods.join(", ");
    }
    
    // Enable cookies to be sent in CORS requests.
    void allowCredentials() {
       _headers["Access-Control-Allow-Credentials"] = "true";
    }
    
    /**
     * Allowed headers that can be sent in CORS requests.
     *
     * headersToAccept - The list of headers to accept in CORS requests.
     */
    void allowHeaders(string[] headersToAccept) {
       _headers["Access-Control-Allow-Headers"] = headersToAccept.join(", ");
    }
    
    // Define the headers a client library/browser can expose to scripting
    auto exposeHeaders(string[] corsResponseHeaders) {
       _headers["Access-Control-Expose-Headers"] = corsResponseHeaders.join(", ");

        return this;
    }
    
    /**
     * Define the max-age preflight OPTIONS requests are valid for.
     * Params:
     * string|int age The max-age for OPTIONS requests in seconds
     */
    auto maxAge(string|int age) {
       _headers["Access-Control-Max-Age"] = age;

        return this;
    }
}
