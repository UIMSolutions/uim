module http.uim.http.interfaces.session;

import uim.http;

@safe:

interface ISession {
    // Unique session id of this session.
    string id();
}