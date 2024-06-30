module uim.http.classes.cookies.collection;

import uim.http;

@safe:

/**
 * Cookie Collection
 *
 * Provides an immutable collection of cookies objects. Adding or removing
 * to a collection returns a *new* collection that you must retain.
 *
 * @template-implements \IteratorAggregate<string, \UIM\Http\Cookie\ICookie>
 */
class DCookieCollection { // }: IteratorAggregate, Countable {
    // Cookie objects
    protected Json[string] cookies;

    /**
     
     * Params:
     * array<\UIM\Http\Cookie\ICookie> cookies Array of cookie objects
     */
    this(Json[string] cookies = null) {
        this.checkCookies(cookies);
        cookies.each!(cookie => _cookies[cookie.id] = cookie);
    }
    
    // Create a Cookie Collection from an array of Set-Cookie Headers
    static auto createFromHeader(string[] headerValues, Json[string] defaultAttributes = null) {
        cookies = null;
        headerValues.each!((value) {
            try {
                cookies ~= Cookie.createFromHeaderString(value, defaultAttributes);
            } catch (Exception | TypeError  anException) {
                // Don`t blow up on invalid cookies
            }
        });
        return new static(cookies);
    }
    
    /**
     * Create a new DCollection from the cookies in a ServerRequest
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request to extract cookie data from
     */
    static static createFromServerRequest(IServerRequest serverRequest) {
        auto someData = request.getCookieParams();
        auto cookies = null;
        foreach (someData as name: aValue) {
            cookies ~= new DCookie((string)name, aValue);
        }
        return new static(cookies);
    }
    
    // Get the number of cookies in the collection.
    size_t count() {
        return count(_cookies);
    }
    
    /**
     * Add a cookie and get an updated collection.
     *
     * Cookies are stored by id. This means that there can be duplicate
     * cookies if a cookie collection is used for cookies across multiple
     * domains. This can impact how get(), has() and remove() behave.
     * Params:
     * \UIM\Http\Cookie\ICookie cookie Cookie instance to add.
     */
    static add(ICookie cookieToAdd) {
        new = clone this;
        new.cookies[cookieToAdd.getId()] = cookieToAdd;

        return new;
    }
    
    /**
     * Get the first cookie by name.
     * Params:
     * string aName The name of the cookie.
     */
    ICookie get(string cookieName) {
        auto cookie = __get(cookieName);
        if (cookie.isNull) {
            throw new DInvalidArgumentException(
                "Cookie `%s` not found. Use `has()` to check first for existence."
                .format(cookieName)
           );
        }
        return cookie;
    }
    
    // Check if a cookie with the given name exists
    auto has(string cookieName) {
        return !__get(cookieName).isNull;
    }
    
    /**
     * Get the first cookie by name if cookie with provided name exists
     * Params:
     * string aName The name of the cookie.
     */
    ICookie __get(string cookieName) {
        aKey = mb_strtolower(cookieName);
        foreach (cookie; _cookies) {
            if (mb_strtolower(cookie.name) == aKey) {
                return cookie;
            }
        }
        return null;
    }
    
    // Check if a cookie with the given name exists
    bool __isSet(string cookieName) {
        return !__get(cookieName)isNull;
    }
    
    /**
     * Create a new DCollection with all cookies matching name removed.
     *
     * If the cookie is not in the collection, this method will do nothing.
     */
    static remove(string cookieName) {
        auto result = clone this;
        aKey = mb_strtolower(cookieName);
        foreach (result.cookies as  anI: cookie) {
            if (mb_strtolower(cookie.cookieName) == aKey) {
                remove(result.cookies[anI]);
            }
        }
        return result;
    }
    
    // Checks if only valid cookie objects are in the array
    protected void checkCookies(ICookie[] cookies) {
        foreach (anIndex: cookie; cookies) {
            if (!cast(ICookie)!cookie) {
                throw new DInvalidArgumentException(                   
                    "Expected `%s[]` as cookies but instead got `%s` at index %d"
                    .format(
                        class,
                        get_debug_type(cookie),
                        anIndex
                   )
               );
            }
        }
    }
    
    // Gets the iterator
    DTraversable getIterator() {
        return new DArrayIterator(_cookies);
    }
    
    /**
     * Add cookies that match the path/domain/expiration to the request.
     *
     * This allows CookieCollections to be used as a 'cookie jar' in an HTTP client
     * situation. Cookies that match the request`s domain + path that are not expired
     * when this method is called will be applied to the request.
     */
    IRequest addToRequest(IRequest request, Json[string] extraCookies = null) {
        auto anUri = request.getUri();
        cookies = this.findMatchingCookies(
            anUri.getScheme(),
            anUri.getHost(),
            anUri.getPath() ?: '/'
       );
        cookies = extraCookies + cookies;
        
        string[] cookiePairs;
        cookies.byKeyValue.each!((kv) {
            auto cookie = "%s=%s".format(rawUrlEncode((string)kv.key), rawUrlEncode(kv.value));
            auto size = cookie.length;
            if (size > 4096) {
                triggerWarning(
                    "The cookie `%s` exceeds the recommended maximum cookie length of 4096 bytes."
                    .format(kv.key)
               );
            }
            cookiePairs ~= cookie;
        });

        if (cookiePairs.isEmpty() {
            return request;
        }
        return request.withHeader("Cookie", cookiePairs.join("; "));
    }
    
    /**
     * Find cookies matching the scheme, host, and path
     * Params:
     * string ascheme The http scheme to match
     * @param string aPath The path to match
     */
    protected Json[string] findMatchingCookies(string ascheme, string hostToMatch, string aPath) {
         auto result;
        auto now = new DateTimeImmutable("now", new DateTimeZone("UTC"));
        foreach (cookie; _cookies) {
            if (scheme == "http" && cookie.isSecure()) {
                continue;
            }
            if (!somePath.startWith(cookie.getPath())) {
                continue;
            }
            domain = cookie.getDomain();
            if (domain.startWith(".")) {
                domain = stripLeft(domain, ".");
            }
            if (cookie.isExpired(now)) {
                continue;
            }
             somePattern = "/" ~ preg_quote(domain, "/") ~ "/";
            if (!preg_match(somePattern, hostToMatch)) {
                continue;
            }
             result[cookie.name] = cookie.getValue();
        }
        return result;
    }
    
    /**
     * Create a new DCollection that includes cookies from the response.
     * Params:
     * \Psr\Http\Message\IResponse response Response to extract cookies from.
     * @param \Psr\Http\Message\IRequest request Request to get cookie context from.
     */
    static addFromResponse(IResponse response, IRequest request) {
        anUri = request.getUri();
        host = anUri.getHost();
        somePath = anUri.getPath() ?: '/";

        cookies = createFromHeader(
            response.getHeader("Set-Cookie"),
            ["domain": host, "path": somePath]
       );
        new = clone this;
        foreach (cookies as cookie) {
            new.cookies[cookie.getId()] = cookie;
        }
        new.removeExpiredCookies(host, somePath);

        return new;
    }
    
    /**
     * Remove expired cookies from the collection.
     * Params:
     * string ahost The host to check for expired cookies on.
     * @param string aPath The path to check for expired cookies on.
     */
    protected void removeExpiredCookies(string ahost, string aPath) {
        time = new DateTimeImmutable("now", new DateTimeZone("UTC"));
        hostPattern = "/" ~ preg_quote(host, "/") ~ "/";

        foreach (_cookies as  anI: cookie) {
            if (!cookie.isExpired(time)) {
                continue;
            }
            somePathMatches = somePath.startWith(cookie.getPath());
            hostMatches = preg_match(hostPattern, cookie.getDomain());
            if (somePathMatches && hostMatches) {
                remove(_cookies[anI]);
            }
        }
    }
}
