module uim.http.classes.clients.auth.digest;

import uim.http;

@safe:

/**
 * Digest authentication adapter for UIM\Http\Client
 *
 * Generally not directly constructed, but instead used by {@link \UIM\Http\Client}
 * when options["auth"]["type"] is 'digest'
 */
class DDigest {
    /* 
    // Algorithms
    const ALGO_MD5 = "MD5";
    const ALGO_SHA_256 = "SHA-256";
    const ALGO_SHA_512_256 = "SHA-512-256";
    const ALGO_MD5_SESS = "MD5-sess";
    const ALGO_SHA_256_SESS = "SHA-256-sess";
    const ALGO_SHA_512_256_SESS = "SHA-512-256-sess";

    // QOP
    const QOP_AUTH = "auth";
    const QOP_AUTH_INT = "auth-int";

    /**
     * Algorithms <. Hash type
     */
    const HASH_ALGORITHMS = [
        self.ALGO_MD5: "md5",
        self.ALGO_SHA_256: "sha256",
        self.ALGO_SHA_512_256: "sha512/256",
        self.ALGO_MD5_SESS: "md5",
        self.ALGO_SHA_256_SESS: "sha256",
        self.ALGO_SHA_512_256_SESS: "sha512/256",
    ];

    // Instance of UIM\Http\Client
    protected IClient _client;

    // Algorithm
    protected string aalgorithm;

    // Hash type
    protected string ahashType;

    // Is Sess algorithm
    protected bool isSessAlgorithm = false;

    this(IClient httpClient, Json[string] initData = null) {
        initialize(initData);
       _client = httpClient;
    }
    
    // Set algorithm based on credentials
    protected void setAlgorithm(Json[string] credentials) {
        algorithm = credentials.get("algorithm", self.ALGO_MD5);
        if (!isSet(self.HASH_ALGORITHMS[algorithm])) {
            throw new DInvalidArgumentException("Invalid Algorithm. Valid ones are: " ~
                join(",", self.HASH_ALGORITHMS.keys));
        }
        this.algorithm = algorithm;
        this.isSessAlgorithm = indexOf(this.algorithm, "-sess") != false;
        this.hashType = Hash.get(self.HASH_ALGORITHMS, this.algorithm);
    }
    
    // Add Authorization header to the request.
    Request authentication(Request request, Json[string] credentials) {
        if (!isSet(credentials["username"], credentials["password"])) {
            return request;
        }
        if (!isSet(credentials["realm"])) {
            credentials = _getServerInfo(request, credentials);
        }
        if (!isSet(credentials["realm"])) {
            return request;
        }
        setAlgorithm(credentials);
        aValue = _generateHeader(request, credentials);

        return request.withHeader("Authorization", aValue);
    }
    
    /**
     * Retrieve information about the authentication
     *
     * Will get the realm and other tokens by performing
     * another request without authentication to get authentication challenge.
     */
    protected Json[string] _getServerInfo(Request request, Json[string] credentials) {
        auto response = _client.get(
            to!string(request.getUri()),
            [],
            ["auth": ["type": Json(null)]]
        );

        auto aHeader = response.getHeader("WWW-Authenticate");
        if (!aHeader) {
            return null;
        }
        
        auto matches = HeaderUtility.parseWwwAuthenticate(aHeader[0]);
        auto credentials = array_merge(credentials, matches);
        if ((this.isSessAlgorithm || !credentials.isEmpty("qop"))) && credentials.isEmpty("nc"))) {
            credentials["nc"] = 1;
        }
        return credentials;
    }
    
    protected string generateCnonce() {
        return uniqid();
    }
    
    // Generate the header Authorization
    protected string _generateHeader(Request request, Json[string] authCredentials) {
        auto somePath = request.getRequestTarget();

        if (this.isSessAlgorithm) {
            credentials["cnonce"] = this.generateCnonce();
            a1 = hash(this.hashType, authCredentials["username"] ~ ": " ~
                    authCredentials["realm"] ~ ": " ~ authCredentials["password"]) ~ ": " ~
                authCredentials.getString("nonce") ~ ": " ~ authCredentials["cnonce"];
        } else {
            a1 = authCredentials.getString("username") ~ ": " ~ authCredentials["realm"] ~ ": " ~ authCredentials["password"];
        }
        ha1 = hash(this.hashType, a1);
        a2 = request.getMethod() ~ ": " ~ somePath;
        nc = "%08x".format(credentials.get("nc", 1));

        if (credentials.isEmpty("qop")) {
            ha2 = hash(this.hashType, a2);
            response = hash(this.hashType, ha1 ~ ": " ~ credentials["nonce"] ~ ": " ~ ha2);
        } else {
            if (!in_array(credentials["qop"], [self.QOP_AUTH, self.QOP_AUTH_INT])) {
                throw new DInvalidArgumentException("Invalid QOP parameter. Valid types are: " ~
                    join(",", [self.QOP_AUTH, self.QOP_AUTH_INT]));
            }
            if (credentials["qop"] == self.QOP_AUTH_INT) {
                a2 = request.getMethod() ~ ": " ~ somePath ~ ": " ~ hash(this.hashType, (string)request.getBody());
            }
            if (credentials.isEmpty("cnonce")) {
                credentials["cnonce"] = this.generateCnonce();
            }
            
            auto ha2 = hash(this.hashType, a2);
            auto response = hash(
                this.hashType,
                ha1 ~ ": " ~ credentials["nonce"] ~ ": " ~ nc ~ ": " .
                credentials["cnonce"] ~ ": " ~ credentials["qop"] ~ ": " ~ ha2
            );
        }
        string result = "Digest ";
        result ~= "username="" ~ credentials["username"].replace(["\\", """], ["\\\\", "\\""]) ~ "", ";
        result ~= "realm="" ~ credentials["realm"] ~ "", ";
        result ~= "nonce="" ~ credentials["nonce"] ~ "", ";
        result ~= "uri="" ~ somePath ~ "", ";
        result ~= "algorithm="" ~ this.algorithm ~ """;

        if (!authCredentials.isEmpty("qop")) {
            result ~= ", qop=" ~ credentials["qop"];
        }
        if (this.isSessAlgorithm || !authCredentials.isEmpty("qop")) {
            result ~= ", nc=" ~ nc ~ ", cnonce="" ~ credentials["cnonce"] ~ """;
        }
        result ~= ", response="" ~ response ~ """;

        if (!authCredentials.isEmpty("opaque")) {
            result ~= ", opaque="" ~ credentials["opaque"] ~ """;
        }
        return result;
    }
}
