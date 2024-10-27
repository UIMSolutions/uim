module uim.http.classes.clients.responses.vibe;

import uim.http;
import vibe.container.dictionarylist;
static import vibe.internal.interfaceproxy;

@safe:

// Client response based on vibe implementation
class DVibeClientResponse : UIMObject {
    mixin(ResponseThis!("VibeClient"));

    this(HTTPClientResponse response) {
        _response = response;
    }

    // #region Fields
    private HTTPClientResponse _response;

    // The response header fields
    DictionaryList!(string, false, 12L, false) headers;

    // The protocol version of the response - should not be changed
    HTTPVersion httpVersion;

    // The status code of the response, 200 by default
    int statusCode;

    // The status phrase of the response
    string statusPhrase;

    DictionaryList!(vibe.http.common.Cookie, true, 32L, false) m_cookies;
    // #endregion Fields

    // #region Properties
    // An input stream suitable for reading the response body.
    vibe.internal.interfaceproxy.InterfaceProxy!(vibe.core.stream.InputStream) bodyReader() {
        return _response.bodyReader();
    }

    // All cookies that shall be set on the client for this request
    DictionaryList!(vibe.http.common.Cookie, true, 32L, false) cookies() {
        return _response.cookies();
    }

    // Contains the keep-alive 'max' parameter, indicates how many requests a client can make before the server closes the connection.
    int maxRequests() {
        return _response.maxRequests();
    }

    // Shortcut to the "Content-Type" header
    string contentType() {
        return _response.contentType();
    }

    void contentType(string type) {
        return _response.contentType(type);
    }
    // #endregion Properties

    // #region Methods
    // Forcefully terminates the connection regardless of the current state.
    void disconnect() {
        if (_response !is null)
            _response.disconnect;
    }

    // Reads and discards the response body.
    void dropBody() {
        if (_response !is null)
            _response.dropBody;
    }

    // Reads the whole response body and tries to parse it as JSON.
    Json readJson() {
        return _response !is null
            ? _response.readJson : Json(null);
    }

    // Provides unsafe means to read raw data from the connection.
    void readRawBody(scope void delegate(scope vibe.internal.interfaceproxy.InterfaceProxy!(vibe.core.stream.InputStream)) del) {
        // _response.readRawBody(del); */
    }

    void readRawBody(scope void delegate(scope InputStream) del) {
        _response.readRawBody(del);
    }

    // Switches the connection to a new protocol and returns the resulting ConnectionStream.
    ConnectionStream switchProtocol(string newProtocol) {
        return _response.switchProtocol(newProtocol);
    }

    void switchProtocol(
        string newProtocol,
        scope void delegate(ConnectionStream) del
    ) {
        _response.switchProtocol(newProtocol, del);
    }

    override string toString() {
        return _response !is null
            ? _response.toString : null;
    }
    // #endregion Methods
}

mixin(ResponseCalls!("VibeClient"));
