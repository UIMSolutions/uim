module uim.oop.networks;

import uim.oop;

@safe:

/**
 * UIM network socket connection class.
 *
 * Core base class for network communication.
 */
class DSocket {
    mixin TConfigurable;
    
    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    /* 
    // Default configuration settings for the socket connection
    configuration.updateDefaults([
        "persistent": false.toJson,
        "host": "localhost",
        "protocol": "tcp",
        "port": 80,
        "timeout": 30,
    ];

    // Reference to socket connection resource
    protected resource aConnection;

    // This boolean contains the current state of the Socket class
    protected bool connected = false;

    // This variable contains an array with the last error number (num) and string (str)
    protected Json[string] lastError = null;

    // True if the socket stream is encrypted after a {@link \UIM\Network\Socket.enableCrypto()} call
    protected bool encrypted = false;

    /**
     * Contains all the encryption methods available
     */
    protected int[string] _encryptMethods = [
        "sslv23_client": STREAM_CRYPTO_METHOD_SSLv23_CLIENT,
        "tls_client": STREAM_CRYPTO_METHOD_TLS_CLIENT,
        "tlsv10_client": STREAM_CRYPTO_METHOD_TLSv1_0_CLIENT,
        "tlsv11_client": STREAM_CRYPTO_METHOD_TLSv1_1_CLIENT,
        "tlsv12_client": STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT,
        "sslv23_server": STREAM_CRYPTO_METHOD_SSLv23_SERVER,
        "tls_server": STREAM_CRYPTO_METHOD_TLS_SERVER,
        "tlsv10_server": STREAM_CRYPTO_METHOD_TLSv1_0_SERVER,
        "tlsv11_server": STREAM_CRYPTO_METHOD_TLSv1_1_SERVER,
        "tlsv12_server": STREAM_CRYPTO_METHOD_TLSv1_2_SERVER,
    ];

    /**
     * Used to capture connection warnings which can happen when there are
     * SSL errors for example.
     */
    protected string[] _connectionErrors = null;

    /**
     * Connect the socket to the given host and port.
     */
    bool connect() {
        if (this.connection) {
            this.disconnect();
        }
        if (configuration.getString("host").contains(": //")) {
            [configuration.get("protocol"), configuration.get("host")] = configuration.getString("host").split(": //");
        }
        scheme = null;
        if (!configuration.isEmpty("protocol")) {
            scheme = configuration.get("protocol"]~": //";
        }
        _setSslContext(configuration.get("host"));
        context = !configuration..isEmpty("context"))
            ? stream_context_create(configuration.get("context"))
            : stream_context_create();

        connectAs = STREAM_CLIENT_CONNECT;
        if (configuration.hasKey("persistent")) {
            connectAs |= STREAM_CLIENT_PERSISTENT;
        }
        /**
         * @psalm-suppress InvalidArgument
         * @Dstan-ignore-next-line
         */
        set_error_handler(_connectionErrorHandler(...));
        string remoteSocketTarget = scheme ~ configuration.getString("host");
        auto port = configuration.getInteger("port");
        if (port > 0) {
            remoteSocketTarget ~= ": " ~ port;
        }
        auto errNum = 0;
        auto errStr = "";
        _connection = _getStreamSocketClient(
            remoteSocketTarget,
            errNum,
            errStr,
            to!int(configuration.get("timeout"]),
            connectAs,
            context
       );
        restore_error_handler();

        if (this.connection.isNull && (!errNum || !errStr)) {
            setLastError(errNum, errStr);
            throw new DSocketException(errStr, errNum);
        }
        if (this.connection.isNull && _connectionErrors) {
            throw new DSocketException(
                _connectionErrors.join("\n"),
                E_WARNING
           );
        }
        this.connected = isResource(this.connection);
        if (this.connected) {
            assert(this.connection!is null);

            stream_set_timeout(this.connection, (int) configuration.get("timeout"]);
        }
        return _connected;
    }

    /**
     * Check the connection status after calling `connect()`.
     */
    bool isConnected() {
        return _connected;
    }

    /**
     * Create a stream socket client. Mock utility.
     * Params:
     * string aremoteSocketTarget remote socket
     * @param int errNum error number
     * @param string aerrStr error string
     * @param int timeout timeout
     * @param int connectAs flags
     * @param resource context context
     */
    protected resource | null _getStreamSocketClient(
        string aremoteSocketTarget,
        int & errNum,
        string & errStr,
        inttimeout,
        intconnectAs,
        context
   ) {
        resource = stream_socket_client(
            remoteSocketTarget,
            errNum,
            errStr,
            timeout,
            connectAs,
            context
       );

        if (!resource) {
            return null;
        }

        return resource;
    }

    // Configure the SSL context options.
    protected void _setSslContext(string hostName) {
        _config.byKeyValue
            .filter!(kv => str_starts_with(kv.key, "ssl_"));
        
        .each!((kv) {
            string contextKey = subString(kv.key, 4);
            if (isEmpty(configuration.get("context/ssl/"~contextKey])) {
                configuration.set("context/ssl/"~contextKey, kv.value);
            }
            remove(configuration.getString(kv.key));
        });
        if (!configuration.hasKey("context/ssl.SNI_enabled"])) {
            configuration.set("context/ssl/SNI_enabled", true);
        }
        if (isEmpty(configuration.get("context/ssl.peer_name"])) {
            configuration.set("context/ssl/peer_name", hostName);
        }
        if (configuration.isEmpty("context/ssl/cafile")) {
            configuration.set("context/ssl/cafile", CaBundle.getBundledCaBundlePath());
        }
        if (!configuration.isEmpty("context/ssl/verify_host"])) {
            configuration.set("context/ssl/CN_match", hostName);
        }
        configuration.remove("context/ssl/verify_host");
    }

    /*
     * socket_stream_client() does not populate errNum, or errStr when there are
     * connection errors, as in the case of SSL verification failure.
     *
     * Instead we need to handle those errors manually.
     */
        protected void _connectionErrorHandler(int codeNumber, string message) {
            _connectionErrors ~= message;
        }
        
    // Get the connection context.
        Json[string] context() {
            if (!this.connection) {
                return null;
            }
            return stream_context_get_options(this.connection);
        }
    
        // Get the host name of the current connection.
        string host() {
            if (Validation.ip(configuration.get("host"])) {
                return to!string(gethostbyaddr(configuration.get("host"]);
            }
            return to!string(gethostbyaddr(this.address()));
        }

    // Get the IP address of the current connection.
    string address() {
        return Validation.ip(configuration.get("host"))
            ? configuration.get("host");
            : getHostByName(configuration.getString("host"));
    }

    /**
     * Get all IP addresses associated with the current connection.
     */
    Json[string] addresses() {
        if (Validation.ip(configuration.get("host"))) {
            return ["host": configuration.getString["host"]];
        }
        return gethostbynamel(configuration.getMap("host")) ?  : [];
    }

    // Get the last error as a string.
    string lastError() {
        if (isEmpty(this.lastError)) {
            return null;
        }
        return _lastError.getString("num") ~ ": " ~ _lastError.getString("str");
    }

    /**
     * Set the last error.
     * Params:
     * int errNum Error code
     * @param string aerrStr Error string
     */
    void setLastError(interrNum, string aerrStr) {
        this.lastError = ["num": errNum, "str": errStr];
    }

    /**
     * Write data to the socket.
     * Params:
     * string adata The data to write to the socket.
     */
    int write(string adata) {
        if (!this.connected && !this.connect()) {
            return 0;
        }
        auto totalBytes = someData.length;
        auto written = 0;
        while (written < totalBytes) {
            assert(this.connection!is null);

            auto rv = fwrite(this.connection, subString(someData, written));
            if (rv == false || rv == 0) {
                return written;
            }
            written += rv;
        }
        return written;
    }

    /**
     * Read data from the socket. Returns null if no data is available or no connection could be
     * established.
     * Params:
     * size_t aLength Optional buffer length to read; defaults to 1024
     */
    string read(size_t aLength = 1024) {
        if (length < 0) {
            throw new DInvalidArgumentException("Length must be greater than `0`");
        }
        if (!this.connected && !this.connect()) {
            return null;
        }
        assert(this.connection!is null);
        if (feof(this.connection)) {
            return null;
        }
        buffer = fread(this.connection, length);
        anInfo = stream_get_meta_data(this.connection);
        if (anInfo["timed_out"]) {
            setLastError(E_WARNING, "Connection timed out");

            return null;
        }
        return buffer == false ? null : buffer;
    }

    
    <<  <<  <<  < HEAD /**
     * Disconnect the socket from the current connection.
     *
         */
    == == == =

         // Disconnect the socket from the current connection
        >>>  >>>  > 74 a7b6400cdc9ef55c74d50ddcb3fb9c29d1e0bf bool disconnect() {
            if (!isResource(this.connection)) {
                this.connected = false;

                return true;
            }
            /** @psalm-suppress InvalidPropertyAssignmentValue */
            this.connected = !fclose(this.connection);

            if (!this.connected) {
                this.connection = null;
            }
            return !this.connected;
        }
    
    <<  <<  <<  < HEAD

        == == == =

        

        >>>  >>>  > 74 a7b6400cdc9ef55c74d50ddcb3fb9c29d1e0bf /**
     // Destructor, used to disconnect from current connection.
        auto __destruct() {
            this.disconnect();
        }
    
     * Resets the state of this Socket instance to it"s initial state (before Object.__construct got executed)
     * Params:
     * array|null state Array with key and values to reset
     */
        void reset(arraystate = null) {
            if (state.isEmpty) {
                static anInitialState = null;
                if (isEmpty(anInitialState)) {
                    anInitialState = get_class_vars(classname);
                }
                state = anInitialState;
            }
            foreach (state as aProperty : aValue) {
                this. {
                    aProperty
                }
                 = aValue;
            }
        }
    /**
     * Encrypts current stream socket, using one of the defined encryption methods
     * Params:
     * string atype can be one of "ssl2", "ssl3", "ssl23" or "tls"
     * @param string aclientOrServer can be one of "client", "server". Default is "client"
     */
        void enableCrypto(string atype, string aclientOrServer = "client", bool enable = true) {
            if (!array_key_exists(type ~ "_" ~ clientOrServer, _encryptMethods)) {
                throw new DInvalidArgumentException("Invalid encryption scheme chosen");
            }
            
            auto method = _encryptMethods[type ~ "_" ~ clientOrServer];
            if (method == STREAM_CRYPTO_METHOD_TLS_CLIENT) {
                method |= STREAM_CRYPTO_METHOD_TLSv1_1_CLIENT | STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT;
            }
            if (method == STREAM_CRYPTO_METHOD_TLS_SERVER) {
                method |= STREAM_CRYPTO_METHOD_TLSv1_1_SERVER | STREAM_CRYPTO_METHOD_TLSv1_2_SERVER;
            }
            try {
                if (this.connection.isNull) {
                    throw new DException("You must call connect() first.");
                }
                enableCryptoResult = stream_socket_enable_crypto(this.connection, enable, method);
            } catch (Exception anException) {
                setLastError(null, anException.getMessage());
                throw new DSocketException(anException.getMessage(), null, anException);
            }
            if (enableCryptoResult == true) {
                this.encrypted = enable;

                return;
            }
            errorMessage = "Unable to perform enableCrypto operation on the current socket";
            setLastError(null, errorMessage);
            throw new DSocketException(errorMessage);
        }
    
         // Check the encryption status after calling `enableCrypto()`.
        bool isEncrypted() {
            return _encrypted;
        }
}
