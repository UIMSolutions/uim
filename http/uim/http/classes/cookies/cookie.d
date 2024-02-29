module uim.http.classes.cookies.cookie;

import uim.http;

@safe:

class DCookie : ICookie {
    this() {
        initialize();
    }

    bool initialize(IData[string] configData = null) {
        return true;
    }

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
        self.SAMESITE_LAX,
        self.SAMESITE_STRICT,
        self.SAMESITE_NONE,
    ];

    // Get the id for a cookie
    string getId() {
        return null; 
    }

    // Get the path attribute.
    string getPath() {
        return null; 
    }

    // Get the domain attribute.
    string getDomain() {
        return null; 
    }
}
