module uim.http.classes.cookies.cookie;

import uim.http;

@safe:

class DCookie : ICookie {
    mixin TConfigurable!();

    this() { initialize; }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Expires attribute format.
    const string EXPIRES_FORMAT = "D, d-M-Y H:i:s T";

    // SameSite attribute value: Lax
    const string SAMESITE_LAX = "Lax";

    // SameSite attribute value: Strict
    const string SAMESITE_STRICT = "Strict";

    // SameSite attribute value: None
    const string SAMESITE_NONE = "None";

    // Valid values for "SameSite" attribute.
    const string[] SAMESITE_VALUES = [
        SAMESITE_LAX,
        SAMESITE_STRICT,
        SAMESITE_NONE,
    ];

    // Get the id for a cookie
    string getId() {
        return null; 
    }

    // Get the path attribute.
    string getPath() {
        return null; 
    }

    // Get the timestamp from the expiration time
    int getExpiresTimestamp() {
        return 0;
    }

    // Builds the expiration value part of the header string
    string getFormattedExpires() {
        return null; 
    }

    // Get the domain attribute.
    
    string getDomain() {
        return null; 
    }

    // Check if the cookie is HTTP only
    bool isHttpOnly() {
        return false;
    }

    // Create a cookie with HTTP Only updated
    static void withHttpOnly(bool httpOnly);

    // Check if the cookie is secure
    bool isSecure() {
        return false;
    }

    // Create a cookie with Secure updated
    static void withSecure(bool secure) {
    }

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
    IData[string] getOptions() {
        return null;
    }

    // Get cookie data as array.
    IData[string] toArray() {
        return null;
    }

    // Returns the cookie as header value
    string toHeaderValue() {
        return null;
    }
}
