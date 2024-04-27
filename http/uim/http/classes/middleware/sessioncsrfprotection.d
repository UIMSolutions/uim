module uim.http.classes.middleware.sessioncsrfprotection;

import uim.http;

@safe:

/**
 * Provides CSRF protection via session based tokens.
 *
 * This middleware adds a CSRF token to the session. Each request must
 * contain a token in request data, or the X-CSRF-Token header on each PATCH, POST,
 * PUT, or DELETE request. This follows a `synchronizer token' pattern.
 *
 * If the request data is missing or does not match the session data,
 * an InvalidCsrfTokenException will be raised.
 *
 * This middleware integrates with the FormHelper automatically and when
 * used together your forms will have CSRF tokens automatically added
 * when `this.Form.create(...)` is used in a view.
 *
 * If you use this middleware *do not* also use CsrfProtectionMiddleware.
 *
 * @see https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html#synchronizer-token-pattern
 */
class DSessionCsrfProtectionMiddleware { // }: IHttpMiddleware {
    /**
     * Config for the CSRF handling.
     *
     * - `key` The session key to use. Defaults to `csrfToken`
     * - `field` The form field to check. Changing this will also require configuring
     *   FormHelper.
     *
     * /
    protected Json _config = [
        "key": StringData("csrfToken"),
        "field": StringData("_csrfToken"),
    ];

    /**
     * Callback for deciding whether to skip the token check for particular request.
     *
     * CSRF protection token check will be skipped if the callback returns `true`.
     *
     * @var callable|null
     * /
    protected skipCheckCallback;

    const int TOKEN_VALUE_LENGTH = 32;

    this(Json[string] configData = null) {
       _config = configData + _config;
    }
    
    /**
     * Checks and sets the CSRF token depending on the HTTP verb.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request.
     * @param \Psr\Http\Server\IRequestHandler handler The request handler.
     * /
    IResponse process(IServerRequest serverRequest, IRequestHandler handler) {
        method = request.getMethod();
        hasData = in_array(method, ["PUT", "POST", "DELETE", "PATCH"], true)
            || request.getParsedBody();

        if (
            hasData
            && this.skipCheckCallback !isNull
            && call_user_func(this.skipCheckCallback, request) == true
        ) {
            request = this.unsetTokenField(request);

            return handler.handle(request);
        }
        session = request.getAttribute("session");
        if (!session || !(cast(DSession)session)) {
            throw new UimException("You must have a `session` attribute to use session based CSRF tokens");
        }
        token = session.read(configuration.get("key"]);
        if (token is null) {
            token = this.createToken();
            session.write(configuration.get("key"], token);
        }
        request = request.withAttribute("csrfToken", this.saltToken(token));

        if (method == "GET") {
            return handler.handle(request);
        }
        if (hasData) {
            this.validateToken(request, session);
            request = this.unsetTokenField(request);
        }
        return handler.handle(request);
    }
    
    /**
     * Set callback for allowing to skip token check for particular request.
     *
     * The callback will receive request instance as argument and must return
     * `true` if you want to skip token check for the current request.
     * Params:
     * callable aCallback A callable.
     * /
    void skipCheckCallback(callable aCallback) {
        this.skipCheckCallback = aCallback;
    }
    
    /**
     * Apply entropy to a CSRF token
     *
     * To avoid BREACH apply a random salt value to a token
     * When the token is compared to the session the token needs
     * to be unsalted.
     *
     * tokenToSalt - The token to salt.
     * /
    string saltToken(string tokenToSalt) {
        string decodedToken = base64_decode(tokenToSalt);
        auto tokenLength = decodedToken.length;
        string salt = Security.randomBytes(length);
        string salted;
        for (anI = 0;  anI < length;  anI++) {
            // XOR the token and salt together so that we can reverse it later.
            salted ~= chr(ord(decodedToken[anI]) ^ ord(salt[anI]));
        }
        return base64_encode(salted ~ salt);
    }
    
    /**
     * Remove the salt from a CSRF token.
     *

     * If the token is not TOKEN_VALUE_LENGTH * 2 it is an old
     * unsalted value that is supported for backwards compatibility.
     * Params:
     * string atoken The token that could be salty.
     * /
    protected string unsaltToken(string atoken) {
        string decodedToken = base64_decode(token, true);
        if (decodedToken == false || decodedToken.length != TOKEN_VALUE_LENGTH * 2) {
            return token;
        }
        salted = substr(decodedToken, 0, TOKEN_VALUE_LENGTH);
        salt = substr(decodedToken, TOKEN_VALUE_LENGTH);

        unsalted = "";
        for (anI = 0;  anI < TOKEN_VALUE_LENGTH;  anI++) {
            // Reverse the XOR to desalt.
            unsalted ~= chr(ord(salted[anI]) ^ ord(salt[anI]));
        }
        return base64_encode(unsalted);
    }
    
    /**
     * Remove CSRF protection token from request data.
     *
     * This ensures that the token does not cause failures during
     * form tampering protection.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request object.
     * /
    protected IServerRequest unsetTokenField(IServerRequest serverRequest) {
        body = request.getParsedBody();
        if (isArray(body)) {
            unset(body[configuration.get("field"]]);
            request = request.withParsedBody(body);
        }
        return request;
    }
    
    /**
     * Create a new token to be used for CSRF protection
     *
     * This token is a simple unique random value as the compare
     * value is stored in the session where it cannot be tampered with.
     * /
    string createToken() {
        return base64_encode(Security.randomBytes(TOKEN_VALUE_LENGTH));
    }
    
    /**
     * Validate the request data against the cookie token.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request to validate against.
     * @param \UIM\Http\Session session The session instance.
     * /
    protected void validateToken(IServerRequest serverRequest, Session session) {
        auto token = session.read(configuration.get("key"]);
        if (!token || !isString(token)) {
            throw new DInvalidCsrfTokenException(__d("uim", "Missing or incorrect CSRF session key"));
        }
        body = request.getParsedBody();
        if (isArray(body) || cast(DArrayAccess)body) {
            post = to!string(Hash.get(body, configuration.get("field"]));
            post = this.unsaltToken(post);
            if (hash_equals(post, token)) {
                return;
            }
        }
         aHeader = request.getHeaderLine("X-CSRF-Token");
         aHeader = this.unsaltToken(aHeader);
        if (hash_equals(aHeader, token)) {
            return;
        }
        throw new DInvalidCsrfTokenException(__d(
            'uim",
            'CSRF token from either the request body or request headers did not match or is missing.'
        ));
    }
    
    /**
     * Replace the token in the provided request.
     *
     * Replace the token in the session and request attribute. Replacing
     * tokens is a good idea during privilege escalation or privilege reduction.
     * Params:
     * \UIM\Http\ServerRequest serverRequest The request to update
     * @param string aKey The session key/attribute to set.
     * /
    static ServerRequest replaceToken(ServerRequest serverRequest, string aKey = "csrfToken") {
        middleware = new DSessionCsrfProtectionMiddleware(["key": aKey]);

        token = middleware.createToken();
        request.getSession().write(aKey, token);

        return request.withAttribute(aKey, middleware.saltToken(token));
    } */
}
