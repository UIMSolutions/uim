/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
        cookies.each!(cookie => _cookies[cookie.id] = cookie);
    }
    
    // Create a Cookie Collection from an array of Set-Cookie Headers
    static DCookieCollection createFromHeader(string[] headerValues, Json[string] defaultAttributes = null) {
        auto cookies = null;
       /*  headerValues.each!((value) {
            try {
                cookies ~= Cookie.createFromHeaderString(value, defaultAttributes);
            } catch (Exception | TypeError  anException) {
                // Don`t blow up on invalid cookies
            }
        }); */
        // return new static(cookies);
        return null; 
    }
    
    // Create a new DCollection from the cookies in a ServerRequest
    static DCookieCollection createFromServerRequest(IServerRequest request) {
        /* auto items = request.getCookieParams();
        auto cookies = items.byKeyValue.each!(item => new DCookie(item.key, item.value)).array;
        return new DCookieCollection(cookies); */
        return null; 
    }
    
    // Get the number of cookies in the collection.
    size_t count() {
        // return _cookies.length;
        return 0; 
    }
    
    /**
     * Add a cookie and get an updated collection.
     *
     * Cookies are stored by id. This means that there can be duplicate
     * cookies if a cookie collection is used for cookies across multiple
     * domains. This can impact how get(), has() and removeKey() behave.
     */
    static DCookieCollection add(DCookie cookie) {
        /* DCookieCollection cookieCollection = this.clone;
        cookieCollection.cookies[cookie.id()] = cookie;

        return cookieCollection; */
        return null; 
    }
    
    // Get the first cookie by name.
    ICookie get(string cookieName) {
        // auto cookie = __get(cookieName);
        /* if (cookie.isNull) { */
            /* throw new DInvalidArgumentException(
                "Cookie `%s` not found. Use `has()` to check first for existence."
                .format(cookieName)
           ); */
        /* } */
        // return cookie;
        return null; 
    }
    
    // Check if a cookie with the given name exists
    bool has(string cookieName) {
        // return !__get(cookieName).isNull;
        return false;
    }
    
    // Get the first cookie by name if cookie with provided name exists
    ICookie __get(string cookieName) {
        /* aKey = mb_strtolower(cookieName);
        foreach (cookie; _cookies) {
            if (mb_strtolower(cookie.name) == aKey) {
                return cookie;
            }
        } */
        return null;
    }
    
    // Check if a cookie with the given name exists
    bool __isSet(string cookieName) {
        // return !__get(cookieName).isNull;
        return false; 
    }
    
    /**
     * Create a new DCollection with all cookies matching name removed.
     *
     * If the cookie is not in the collection, this method will do nothing.
     */
    static DCookieCollection removeKey(string cookieName) {
        //auto result = this.clone;
        /* string key = cookieName.lower;
        foreach (index, cookie; result.cookies) {
            if (cookie.cookieName.lower == key) {
                removeKey(result.cookies[index]);
            }
        } */
        // return result;
        return null; 
    }
    
    /**
     * Add cookies that match the path/domain/expiration to the request.
     *
     * This allows CookieCollections to be used as a 'cookie jar' in an HTTP client
     * situation. Cookies that match the request`s domain + path that are not expired
     * when this method is called will be applied to the request.
     */
    IRequest addToRequest(IRequest request, Json[string] extraCookies = null) {
        /* auto anUri = request.getUri();
        cookies = this.findMatchingCookies(
            anUri.getScheme(),
            anUri.getHost(),
            anUri.path() ? anUri.path() : '/'
       );
        cookies = extraCookies + cookies;
        
        string[] cookiePairs;
        cookies.byKeyValue.each!((kv) {
            auto cookie = "%s=%s".format(rawUrlEncode(/* (string) * /kv.key), rawUrlEncode(kv.value));
            auto size = cookie.length;
            if (size > 4096) {
                triggerWarning(
                    "The cookie `%s` exceeds the recommended maximum cookie length of 4096 bytes."
                    .format(kv.key)
               );
            }
            cookiePairs ~= cookie;
        });

        return cookiePairs.isEmpty()
            ? request
            : request.withHeader("Cookie", cookiePairs.join("; ")); */
            return null; 
    }
    
    // Find cookies matching the scheme, host, and path
    protected Json[string] findMatchingCookies(string hhtpScheme, string hostToMatch, string pathToMatch) {
        Json[string] result;
        /* auto now = new DateTimeImmutable("now", new DateTimeZone("UTC"));
        foreach (cookie; _cookies) {
            if (hhtpScheme == "http" && cookie.isSecure()) {
                continue;
            }
            if (!pathToMatch.startWith(cookie.path())) {
                continue;
            }
            
            auto domain = cookie.domain();
            if (domain.startWith(".")) {
                domain = stripLeft(domain, ".");
            }
            if (cookie.isExpired(now)) {
                continue;
            }
            
            string pattern = "/" ~ preg_quote(domain, "/").correctUrl;
            if (!preg_match(pattern, hostToMatch)) {
                continue;
            }
             result[cookie.name] = cookie.value();
        } */
        return result;
    }
    
    // Create a new DCollection that includes cookies from the response.
    static DCookieCollection addFromResponse(IResponse response, IRequest request) {
        /* auto anUri = request.getUri();
        auto host = anUri.getHost();
        auto somePath = anUri.path() ? anUri.path() : "/";

        auto cookies = createFromHeader(
            response.getHeader("Set-Cookie"),
            ["domain": host, "path": somePath]
       );
        DCookieCollection newCC = this.clone;
        foreach (cookie; cookies) {
            newCC.cookies[cookie.id()] = cookie;
        }
        newCC.removeExpiredCookies(host, somePath); */

        /* return newCC; */
        return null; 
    }
    
    // Remove expired cookies from the collection.
    protected void removeExpiredCookies(string hostToCheck, string pathToCheck) {
        /* auto time = new DateTimeImmutable("now", new DateTimeZone("UTC"));
        string hostPattern = "/" ~ preg_quote(hostToCheck, "/").correctUrl;

        foreach (index, cookie; _cookies) {
            if (!cookie.isExpired(time)) {
                continue;
            }

            auto somePathMatches = somePath.startWith(cookie.path());
            auto hostMatches = preg_match(hostPattern, cookie.domain());
            if (somePathMatches && hostMatches) {
                removeKey(_cookies[index]);
            }
        } */
    }
}
