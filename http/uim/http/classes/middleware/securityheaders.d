module uim.http.classes.middleware.securityheaders;

import uim.http;

@safe:

// Handles common security headers in a convenient way
class DSecurityHeadersMiddleware { // }: IHttpMiddleware { 
    // X-Content-Type-Option nosniff */
    const string NOSNIFF = "nosniff";

    // X-Download-Option noopen */
    const string NOOPEN = "noopen";

    /// Referrer-Policy no-referrer */
    const string NO_REFERRER = "no-referrer";

    // Referrer-Policy no-referrer-when-downgrade */
    const string NO_REFERRER_WHEN_DOWNGRADE = "no-referrer-when-downgrade";

    // string Referrer-Policy origin */
    const string ORIGIN = "origin";

    // Referrer-Policy origin-when-cross-origin */
    const string ORIGIN_WHEN_CROSS_ORIGIN = "origin-when-cross-origin";

    // Referrer-Policy same-origin */
    const string SAME_ORIGIN = "Same-origin";

    // Referrer-Policy strict-origin */
    const string STRICT_ORIGIN = "Strict-origin";

    // Referrer-Policy strict-origin-when-cross-origin */
    const string STRICT_ORIGIN_WHEN_CROSS_ORIGIN = "Strict-origin-when-cross-origin";

    // Referrer-Policy unsafe-url */
    const string UNSAFE_URL = "unsafe-url";

    // X-Frame-Option deny */
    const string DENY = "deny";

    // X-Frame-Option sameorigin */
    const string SAMEORIGIN = "Sameorigin";

    /** @var string X-Frame-Option allow-from */
    const ALLOW_FROM = "allow-from";

    /** @var string X-XSS-Protection block, sets enabled with block */
    const XSS_BLOCK = "block";

    /** @var string X-XSS-Protection enabled with block */
    const XSS_ENABLED_BLOCK = "1; mode=block";

    /** @var string X-XSS-Protection enabled */
    const XSS_ENABLED = "1";

    /** @var string X-XSS-Protection disabled */
    const XSS_DISABLED = "0";

    /** @var string X-Permitted-Cross-Domain-Policy all */
    const ALL = "all";

    /** @var string X-Permitted-Cross-Domain-Policy none */
    const NONE = "none";

    /** @var string X-Permitted-Cross-Domain-Policy master-only */
    const MASTER_ONLY = "master-only";

    /** @var string X-Permitted-Cross-Domain-Policy by-content-type */
    const BY_CONTENT_TYPE = "by-content-type";

    /** @var string X-Permitted-Cross-Domain-Policy by-ftp-filename */
    const BY_FTP_FILENAME = "by-ftp-filename";

    // Security related headers to set
    protected Json[string] _headers;

    /**
     * X-Content-Type-Options
     *
     * Sets the header value for it to 'nosniff'
     *
     * @link https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options
     */
    void noSniff() {
        _headers["x-content-type-options"] = Json(NOSNIFF);
    }
    
    /**
     * X-Download-Options
     *
     * Sets the header value for it to 'noopen'
     *
     * @link https://msdn.microsoft.com/en-us/library/jj542450(v=vs.85).aspx
     */
    void noOpen() {
        _headers["x-download-options"] = Json(NOOPEN);
    }
    
    /**
     * Referrer-Policy
     *
     * @link https://w3c.github.io/webappsec-referrer-policy
     * @param string policyValue Policy value.
     */
    void setReferrerPolicy(string policyValue = SAME_ORIGIN) {
        // policyValue = Available Value: 'no-referrer", "no-referrer-when-downgrade", "origin",
        // 'origin-when-cross-origin", "same-origin", "strict-origin", "strict-origin-when-cross-origin", "unsafe-url'
        auto available = [
            NO_REFERRER,
            NO_REFERRER_WHEN_DOWNGRADE,
            ORIGIN,
            ORIGIN_WHEN_CROSS_ORIGIN,
            SAME_ORIGIN,
            STRICT_ORIGIN,
            STRICT_ORIGIN_WHEN_CROSS_ORIGIN,
            UNSAFE_URL,
        ];

        checkValues(policyValue, available);
        _headers["referrer-policy"] = policyValue;
    }
    
    // X-Frame-Options
    // optionValue - Option value. Available Values: 'deny", "sameorigin", "allow-from <uri>'
    // url - URL if mode is `allow-from`
    void setXFrameOptions(string optionValue = SAMEORIGIN, string url = null) {
        checkValues(optionValue, [DENY, SAMEORIGIN, ALLOW_FROM]);

        if (optionValue == ALLOW_FROM) {
            if (url.isEmpty) {
                throw new DInvalidArgumentException("The 2nd arg url can not be empty when `allow-from` is used");
            }
            optionValue ~= " " ~ url;
        }
        _headers.set("x-frame-options", optionValue);
    }
    
    /**
     * X-XSS-Protection. It`s a non standard feature and outdated. For modern browsers
     * use a strong Content-Security-Policy that disables the use of inline JavaScript
     * via 'unsafe-inline' option.
     *
     * @param string amode Mode value. Available Values: '1", "0", "block'
     */
    void setXssProtection(string modeValue = XSS_BLOCK) {
        if (modeValue == XSS_BLOCK) {
            modeValue = XSS_ENABLED_BLOCK;
        }
        checkValues(modeValue, [XSS_ENABLED, XSS_DISABLED, XSS_ENABLED_BLOCK]);
        _headers["x-xss-protection"] = modeValue;
    }
    
    /**
     * X-Permitted-Cross-Domain-Policies
     *
     * @link https://web.archive.org/web/20170607190356/https://www.adobe.com/devnet/adobe-media-server/articles/cross-domain-xml-for-streaming.html
     * @param string apolicy Policy value. Available Values: 'all", "none", "master-only", "by-content-type",
     *   'by-ftp-filename'
     */
    void setCrossDomainPolicy(string policyValue = ALL) {
        checkValues(policyValue, [
            ALL,
            NONE,
            MASTER_ONLY,
            BY_CONTENT_TYPE,
            BY_FTP_FILENAME,
        ]);
        _headers["x-permitted-cross-domain-policies"] = policyValue;
    }
    
    // Convenience method to check if a value is in the list of allowed args
    protected void checkValues(string valueToCheck, string[] allowedValues) {
        if (!isIn(valueToCheck, allowedValues, true)) {
            array_walk(allowedValues, fn (&x): x = "`x`");
            throw new DInvalidArgumentException(
                "Invalid arg `%s`, use one of these: %s."
                .format(valueToCheck, allowedValues.join(", ")
           ));
        }
    }
    
    /**
     * Serve assets if the path matches one.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request.
     * @param \Psr\Http\Server\IRequestHandler handler The request handler.
     */
    IResponse process(IServerRequest serverRequest, IRequestHandler handler) {
        response = handler.handle(request);
        _headers.byKeyValue
            .each!(headerValue => response = response.withHeader(headerValue.key, headerValue.value));
        return response;
    }
}
