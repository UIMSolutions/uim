/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.networks;

import uim.oop;

@safe:

/**
 * UIM network socket connection class.
 * Core base class for network communication.
 */
class DSocket : UIMObject {
  this() {
    super.initialize;
  }

  this(Json[string] initData) {
    super(initData);
  }

  this(string name) {
    super(name);
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    configuration
      .setDefault("persistent", false.toJson)
      .setDefault("host", "localhost")
      .setDefault("protocol", "tcp")
      .setDefault("port", 80)
      .setDefault("timeout", 30);

    /* _encryptMethods = [
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
    ]; */

    return true;
  }

  // Reference to socket connection resource
  // protected resource _connection;

  // This boolean contains the current state of the Socket class
  protected bool _connected = false;

  // This variable contains an array with the last error number (num) and string (str)
  protected Json[string] _lastError = null;

  // True if the socket stream is encrypted after a {@link \UIM\Network\Socket.enableCrypto()} call
  protected bool _encrypted = false;

  // Contains all the encryption methods available
  protected int[string] _encryptMethods;

  /**
     * Used to capture connection warnings which can happen when there are
     * SSL errors for example.
     */
  protected string[] _connectionErrors = null;

  // Connect the socket to the given host and port.
  bool connect() {
    /* if (_connection) {
      disconnect();
    }
    if (configuration.getString("host").contains(": //")) {
      [configuration.get("protocol"), configuration.get("host")] = configuration.getString("host")
        .split(": //");
    }
    auto scheme = null;
    if (!configuration.isEmpty("protocol")) {
      scheme = configuration.getString("protocol") ~ ": //";
    }
    _setSslContext(configuration.get("host"));
    context = !configuration.isEmpty("context")
      ? stream_context_create(configuration.get("context")) : stream_context_create();

    connectFlags = STREAM_CLIENT_CONNECT;
    if (configuration.hasKey("persistent")) {
      connectFlags |= STREAM_CLIENT_PERSISTENT;
    }

    // set_error_handler(_connectionErrorHandler(...));
    string remoteSocketTarget = scheme ~ configuration.getString("host");
    auto port = configuration.getInteger("port");
    if (port > 0) {
      remoteSocketTarget ~= ": " ~ port;
    }
    auto errorNumber = 0;
    auto errorString = "";
    _connection = _getStreamSocketClient(
      remoteSocketTarget,
      errorNumber,
      errorString,
      configuration.getLong("timeout"),
      connectFlags,
      context
    );
    restore_error_handler();
    if (_connection.isNull && (!errorNumber || !errorString)) {
      setLastError(errorNumber, errorString);
      throw new DSocketException(
        errorString, errorNumber);
    }
    if (_connection.isNull && _connectionErrors) {
      throw new DSocketException(
        _connectionErrors.join("\n"),
        ERRORS.WARNING
      );
    }
    _connected = isResource(_connection);
    if (_connected) {
      assert(_connection !is null);
      stream_set_timeout(
        _connection, configuration.getLong("timeout"));
    }
    return _connected; */
    return false;
  }

  // Check the connection status after calling `connect()`.
  bool isConnected() {
    return _connected;
  }

  // Create a stream socket client. Mock utility.
  /* protected resource | null _getStreamSocketClient(
        string remoteSocketTarget,
        ref int errorNumber,
        ref string errorString,
        int timeout,
        size_t connectFlags,
        Json[string] context
    ) {
        auto resource = stream_socket_client(
            remoteSocketTarget,
            errorNumber,
            errorString,
            timeout,
            connectFlags,
            context
        );

        return resource
            ? resource : null;
    } */

  // Configure the SSL context options.
  protected void _setSslContext(string hostName) {
    /* _config.byKeyValue
      .filter!(kv => str_starts_with(kv.key, "ssl_"))
      .each!((kv) {
        string contextKey = subString(kv.key, 4);
        if (configuration.isEmpty("context/ssl/" ~ contextKey)) {
          configuration.set("context/ssl/" ~ contextKey, kv.value);
        }
        removeKey(configuration.getString(kv.key));
      });

    configuration.merge("context/ssl.SNI_enabled", true);
    configuration.ifEmpty("context/ssl/peer_name", hostName);
    configuration.ifEmpty("context/ssl/cafile", CaBundle.getBundledCaBundlePath());

    if (!configuration.isEmpty("context/ssl/verify_host")) {
      configuration.set("context/ssl/CN_match", hostName);
    }
    configuration.removeKey("context/ssl/verify_host"); */
  }

  /*
     * socket_stream_client() does not populate errorNumber, or errorString when there are
     * connection errors, as in the case of SSL verification failure.
     *
     * Instead we need to handle those errors manually.
     */
  protected void _connectionErrorHandler(
    int codeNumber, string message) {
    _connectionErrors ~= message;
  }

  // Get the connection context.
  Json[string] context() {
    /* return !_connection
      ? null : stream_context_get_options(_connection); */
    return null; 
  }

  // Get the host name of the current connection.
  string host() {
/*     if (DValidation.ip(configuration.get("host"))) {
      return to!string(gethostbyaddr(
          configuration.get("host")));
    } */
    // return to!string(gethostbyaddr(this.address()));
    return null; 
  }

  // Get the IP address of the current connection.
  string address() {
    /* return DValidation.ip(configuration.get("host"))
      ? configuration.get("host") : getHostByName(
        configuration.getString("host")); */
    return null; 
  }

  // Get all IP addresses associated with the current connection.
  Json[string] addresses() {
    /* if (DValidation.ip(configuration.get("host"))) {
      return [
        "host": configuration.getString["host"]
      ];
    }
    return gethostbynamel(
      configuration.hasKey("host")) ? configuration.getMap("host") : null; */
    return null; 
  }

  // Get the last error as a string.
  string lastError() {
    return _lastError.isEmpty
      ? null : _lastError.getString("num") ~ ": " ~ _lastError.getString("str");
  }

  // Set the last error.
  void setLastError(int errorNumber, string errorString) {
    /* _lastError = [
      "num": errorNumber,
      "str": errorString
    ]; */
  }

  // Write data to the socket.
  void write(string adata) {
    /* if (!_connected && !this.connect()) {
      return 0;
    }
    auto totalBytes = someData
      .length;
    auto written = 0;
    while (
      written < totalBytes) {
      assert(_connection !is null);
      auto rv = fwrite(_connection, subString(
          someData, written));
      if (rv == false || rv == 0) {
        return written;
      }
      written += rv;
    }
    return written; */
    return 0;
  }

  // Read data from the socket. Returns null if no data is available or no connection could be established.
  string read(
    size_t bufferLength = 1024) {
    if (!_connected && !this.connect()) {
      return null;
    }
    /* assert(_connection !is null);
    if (feof(_connection)) {
      return null;
    }

    auto buffer = fread(_connection, bufferLength);
    auto anInfo = stream_get_meta_data(_connection);

    if (anInfo["timed_out"]) {
      setLastError(ERRORS.WARNING, "Connection timed out");
      return null;
    }
    return buffer.isEmpty ? buffer : null; */
    return null; 
  }

  /* <<  <<  <<  < HEAD /**
     * Disconnect the socket from the current connection.
     *
         * /
    ==  ==  ==  = */

  // Disconnect the socket from the current connection
  /* >>>  >>>  > 74 a7b6400cdc9ef55c74d50ddcb3fb9c29d1e0bf  */
  bool disconnect() {
    /* if (
      !isResource(
        _connection)) {
      _connected = false;

      return true;
    }

    _connected = !fclose(
      _connection);

    if (
      !_connected) {
      _connection = null;
    }
    return !_connected; */
    return false;
  }

  /* <<  <<  <<  < HEAD
        ==  ==  ==  =
        >>>  >>>  > 74 a7b6400cdc9ef55c74d50ddcb3fb9c29d1e0bf */ /**
     // Destructor, used to disconnect from current connection.
        auto __destruct() {
            this.disconnect();
        }
    
     * Resets the state of this Socket instance to it"s initial state (before Object.__construct got executed)
     * Params:
     * array|null state Array with key and values to reset
     */
  void reset(Json[string] state = null) {
    /* if (state.isEmpty) {
      static anInitialState = null;
      if (
        isEmpty(
          anInitialState)) {
        anInitialState = get_class_vars(
          classname);
      }

      state = anInitialState;
    }
    foreach (property, value; state) {
      // this. {property}= value;
    } */
  }
  // Encrypts current stream socket, using one of the defined encryption methods
  void enableCrypto(string type, string clientOrServer = "client", bool enable = true) {
    if (!_encryptMethods.hasKey(type ~ "_" ~ clientOrServer)) {
      // throw new DInvalidArgumentException("Invalid encryption scheme chosen");
    }

    auto method = _encryptMethods[type ~ "_" ~ clientOrServer];
    /* if (
      method == STREAM_CRYPTO_METHOD_TLS_CLIENT) {
      method |= STREAM_CRYPTO_METHOD_TLSv1_1_CLIENT | STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT;
    }
    if (
      method == STREAM_CRYPTO_METHOD_TLS_SERVER) {
      method |= STREAM_CRYPTO_METHOD_TLSv1_1_SERVER | STREAM_CRYPTO_METHOD_TLSv1_2_SERVER;
    } */
    /* try {
      if (_connection.isNull) {
        throw new UIMException("You must call connect() first.");
      }
      enableCryptoResult = stream_socket_enable_crypto(_connection, enable, method);
    } catch (UIMException exception) {
      setLastError(null, exception.message());
      throw new DSocketException(
        exception.message(), null, exception);
    }
    if (enableCryptoResult == true) {
      _encrypted = enable;

      return;
    } */

    string errorMessage = "Unable to perform enableCrypto operation on the current socket";
    /* setLastError(null, errorMessage);
    throw new DSocketException(errorMessage); */
  }

  // Check the encryption status after calling `enableCrypto()`.
  bool isEncrypted() {
    return _encrypted;
  }
}
