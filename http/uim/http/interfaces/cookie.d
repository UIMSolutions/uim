
module uim.http.interfaces.cookie;

import uim.http;

@safe:

// use IDateTime;
// Cookie Interface
interface ICookie {
    // Get the id for a cookie
    string getId();

    // Get the path attribute.
    string getPath();

    // Get the domain attribute.
    string getDomain();

/*    // Sets the cookie name
    static void withName(string aName);

    // Gets the cookie name
    string name();

    // Gets the cookie value
    string[] getValue();

    // Gets the cookie value as scalar.
    string getScalarValue();

    /**
     * Create a cookie with an updated value.
     * Params:
     * string[]|float|int|bool aValue Value of the cookie to set
     */
    static withValue(string[]|float|int|bool aValue);


    /**
     * Create a new cookie with an updated path
     * Params:
     * string aPath Sets the path
     * @return static
     */
    auto withPath(string aPath): static;


    /**
     * Create a cookie with an updated domain
     * Params:
     * string adomain Domain to set
     * @return static
     */
    // TODO static withDomain(string adomain);

    /**
     * Get the current expiry time
     */
    // TODO IDateTime getExpiry();

    // Get the timestamp from the expiration time
    int getExpiresTimestamp() ;

    // Builds the expiration value part of the header string
    string getFormattedExpires();

    /**
     * Create a cookie with an updated expiration date
     * Params:
     * \IDateTime dateTime Date time object
     * @return static
     */
    // TODO static withExpiry(IDateTime dateTime);

    /**
     * Create a new cookie that will virtually never expire.
     */
    // TODO static withNeverExpire();

    /**
     * Create a new cookie that will expire/delete the cookie from the browser.
     *
     * This is done by setting the expiration time to 1 year ago
     *
     * @return static
     */
    // TODO auto withExpired(): static;

    /**
     * Check if a cookie is expired when compared to time
     *
     * Cookies without an expiration date always return false.
     * Params:
     * \IDateTime|null time The time to test against. Defaults to 'now' in UTC.
     */
    // TOD bool isExpired(IDateTime time = null);

    // Check if the cookie is HTTP only
    bool isHttpOnly();

    // Create a cookie with HTTP Only updated
    static void withHttpOnly(bool httpOnly);

    // Check if the cookie is secure
    bool isSecure();

    // Create a cookie with Secure updated
    static void withSecure(bool secure);

    /**
     * Get the SameSite attribute.
     */
    // TOD SameSiteEnum getSameSite();

    /**
     * Create a cookie with an updated SameSite option.
     * Params:
     * \UIM\Http\Cookie\SameSiteEnum|string|null sameSite Value for to set for Samesite option.
     */
    // TODO static withSameSite(SameSiteEnum|string|null sameSite);

    // Get cookie options
    Json[string] getOptions();

    // Get cookie data as array.
    Json[string] toArray();

    // Returns the cookie as header value
    string toHeaderValue();
}
