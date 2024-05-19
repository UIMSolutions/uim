module uim.http.classes.middleware.securityheaders;

import uim.http;

@safe:

/**
 * Handles common security headers in a convenient way
 */
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
        _headers["x-content-type-options"] = Json(self.NOSNIFF);
    }
    
    /**
     * X-Download-Options
     *
     * Sets the header value for it to 'noopen'
     *
     * @link https://msdn.microsoft.com/en-us/library/jj542450(v=vs.85).aspx
     */
    void noOpen() {
        _headers["x-download-options"] = Json(self.NOOPEN);
    }
    
    /**
     * Referrer-Policy
     *
     * @link https://w3c.github.io/webappsec-referrer-policy
     * @param string apolicy Policy value. Available Value: 'no-referrer", "no-referrer-when-downgrade", "origin",
     *    'origin-when-cross-origin", "same-origin", "strict-origin", "strict-origin-when-cross-origin", "unsafe-url'
     */
    void setReferrerPolicy(string apolicy = self.SAME_ORIGIN) {
        auto available = [
            self.NO_REFERRER,
            self.NO_REFERRER_WHEN_DOWNGRADE,
            self.ORIGIN,
            self.ORIGIN_WHEN_CROSS_ORIGIN,
            self.SAME_ORIGIN,
            self.STRICT_ORIGIN,
            self.STRICT_ORIGIN_WHEN_CROSS_ORIGIN,
            self.UNSAFE_URL,
        ];

        this.checkValues(policy, available);
        this.headers["referrer-policy"] = policy;
    }
    
    /**
     * X-Frame-Options
     *
     * @link https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
     * @param string aoption Option value. Available Values: 'deny", "sameorigin", "allow-from <uri>'
     * @param string url URL if mode is `allow-from`
     */
    void setXFrameOptions(string aoption = self.SAMEORIGIN, string aurl = null) {
        this.checkValues(option, [self.DENY, self.SAMEORIGIN, self.ALLOW_FROM]);

        if (option == self.ALLOW_FROM) {
            if (url.isEmpty) {
                throw new DInvalidArgumentException("The 2nd arg url can not be empty when `allow-from` is used");
            }
            option ~= " " ~ url;
        }
        this.headers["x-frame-options"] = option;
    }
    
    /**
     * X-XSS-Protection. It`s a non standard feature and outdated. For modern browsers
     * use a strong Content-Security-Policy that disables the use of inline JavaScript
     * via 'unsafe-inline' option.
     *
     * @link https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection
     * @param string amode Mode value. Available Values: '1", "0", "block'
     */
    void setXssProtection(string amode = self.XSS_BLOCK) {
        if (mode == self.XSS_BLOCK) {
            mode = self.XSS_ENABLED_BLOCK;
        }
        this.checkValues(mode, [self.XSS_ENABLED, self.XSS_DISABLED, self.XSS_ENABLED_BLOCK]);
        this.headers["x-xss-protection"] = mode;
    }
    
    /**
     * X-Permitted-Cross-Domain-Policies
     *
     * @link https://web.archive.org/web/20170607190356/https://www.adobe.com/devnet/adobe-media-server/articles/cross-domain-xml-for-streaming.html
     * @param string apolicy Policy value. Available Values: 'all", "none", "master-only", "by-content-type",
     *    'by-ftp-filename'
     */
    void setCrossDomainPolicy(string policyValue = self.ALL) {
        this.checkValues(policyValue, [
            self.ALL,
            self.NONE,
            self.MASTER_ONLY,
            self.BY_CONTENT_TYPE,
            self.BY_FTP_FILENAME,
        ]);
        this.headers["x-permitted-cross-domain-policies"] = policyValue;
    }
    
    /**
     * Convenience method to check if a value is in the list of allowed args
     *
     * @throws \InvalidArgumentException Thrown when a value is invalid.
     * @param string avalue Value to check
     * @param string[] allowed List of allowed values
     */
    protected void checkValues(string avalue, Json[string] allowed) {
        if (!in_array(aValue, allowed, true)) {
            array_walk(allowed, fn (&x): x = "`x`");
            throw new DInvalidArgumentException(
                "Invalid arg `%s`, use one of these: %s."
                .format(aValue,
                allowed.join(", ")
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
        this.headers.byKeyValue
            .each!(headerValue => response = response.withHeader(headerValue.key, headerValue.value));
        return response;
    }
}
