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
     * /
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
    protected bool  isSessAlgorithm = false;

    /**
     * Constructor
     * Params:
     * \UIM\Http\Client client Http client object.
     * @param array|null options Options list.
     * /
    this(IClient httpClient, Json[string] options = null) {
       _client = httpClient;
    }
    
    /**
     * Set algorithm based on credentials
     * Params:
     * array credentials authentication params
     * /
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
    
    /**
     * Add Authorization header to the request.
     * Params:
     * \UIM\Http\Client\Request request The request object.
     * @param Json[string] credentials Authentication credentials.
     * /
    Request authentication(Request request, array credentials) {
        if (!isSet(credentials["username"], credentials["password"])) {
            return request;
        }
        if (!isSet(credentials["realm"])) {
            credentials = _getServerInfo(request, credentials);
        }
        if (!isSet(credentials["realm"])) {
            return request;
        }
        this.setAlgorithm(credentials);
        aValue = _generateHeader(request, credentials);

        return request.withHeader("Authorization", aValue);
    }
    
    /**
     * Retrieve information about the authentication
     *
     * Will get the realm and other tokens by performing
     * another request without authentication to get authentication
     * challenge.
     * Params:
     * \UIM\Http\Client\Request request The request object.
     * @param array credentials Authentication credentials.
     * /
    // TODO protected array _getServerInfo(Request request, array credentials) {
        response = _client.get(
            to!string(request.getUri()),
            [],
            ["auth": ["type": null]]
        );

        aHeader = response.getHeader("WWW-Authenticate");
        if (!aHeader) {
            return null;
        }
        matches = HeaderUtility.parseWwwAuthenticate(aHeader[0]);
        credentials = array_merge(credentials, matches);

        if ((this.isSessAlgorithm || !empty(credentials["qop"])) && empty(credentials["nc"])) {
            credentials["nc"] = 1;
        }
        return credentials;
    }
    
    /**
     * /
    protected string generateCnonce() {
        return uniqid();
    }
    
    /**
     * Generate the header Authorization
     * Params:
     * \UIM\Http\Client\Request request The request object.
     * @param Json[string] credentials Authentication credentials.
     * /
    protected string _generateHeader(Request request, array credentials) {
        somePath = request.getRequestTarget();

        if (this.isSessAlgorithm) {
            credentials["cnonce"] = this.generateCnonce();
            a1 = hash(this.hashType, credentials["username"] ~ ":" .
                    credentials["realm"] ~ ":" ~ credentials["password"]) ~ ":" .
                credentials["nonce"] ~ ":" ~ credentials["cnonce"];
        } else {
            a1 = credentials["username"] ~ ":" ~ credentials["realm"] ~ ":" ~ credentials["password"];
        }
        ha1 = hash(this.hashType, a1);
        a2 = request.getMethod() ~ ":" ~ somePath;
        nc = "%08x".format(credentials.get("nc", 1));

        if (credentials.isEmpty("qop")) {
            ha2 = hash(this.hashType, a2);
            response = hash(this.hashType, ha1 ~ ":" ~ credentials["nonce"] ~ ":" ~ ha2);
        } else {
            if (!in_array(credentials["qop"], [self.QOP_AUTH, self.QOP_AUTH_INT])) {
                throw new DInvalidArgumentException("Invalid QOP parameter. Valid types are: ' .
                    join(",", [self.QOP_AUTH, self.QOP_AUTH_INT]));
            }
            if (credentials["qop"] == self.QOP_AUTH_INT) {
                a2 = request.getMethod() ~ ":" ~ somePath ~ ":" ~ hash(this.hashType, (string)request.getBody());
            }
            if (isEmpty(credentials["cnonce"])) {
                credentials["cnonce"] = this.generateCnonce();
            }
            ha2 = hash(this.hashType, a2);
            response = hash(
                this.hashType,
                ha1 ~ ":" ~ credentials["nonce"] ~ ":" ~ nc ~ ":" .
                credentials["cnonce"] ~ ":" ~ credentials["qop"] ~ ":" ~ ha2
            );
        }
        string authHeader = "Digest ";
        authHeader ~= "username="" ~ credentials["username"].replace(["\\", """], ["\\\\", "\\""]) ~ "", ";
        authHeader ~= "realm="" ~ credentials["realm"] ~ "", ";
        authHeader ~= "nonce="" ~ credentials["nonce"] ~ "", ";
        authHeader ~= "uri="" ~ somePath ~ "", ";
        authHeader ~= "algorithm="" ~ this.algorithm ~ """;

        if (!empty(credentials["qop"])) {
            authHeader ~= ", qop=" ~ credentials["qop"];
        }
        if (this.isSessAlgorithm || !empty(credentials["qop"])) {
            authHeader ~= ", nc=" ~ nc ~ ", cnonce="" ~ credentials["cnonce"] ~ """;
        }
        authHeader ~= ", response="" ~ response ~ """;

        if (!empty(credentials["opaque"])) {
            authHeader ~= ", opaque="" ~ credentials["opaque"] ~ """;
        }
        return authHeader;
    } */
}
