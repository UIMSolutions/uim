module uim.oop.tests.testsession;

import uim.oop;

@safe:

/*
/**
 * A class to contain and retain the session during integration testing.
 * Read only access to the session during testing.
 */
class DTestSession {
    protected Json[string] _session = null;

    /**
     * @param array|null mysession Session data.
     */
    this(Json[string] sessionData) {
        _session = sessionData;
    }
    
    // Returns true if given variable name is set in session.
    bool check(string nameToCheck = null) {
        if (_session.isNull) {
            return false;
        }
        if (nameToCheck.isNull) {
            return (bool)_session;
        }
        return !Hash.get(_session, nameToCheck).isNull;
    }
    
    /**
     * Returns given session variable, or all of them, if no parameters given.
     * Params:
     * string myname The name of the session variable (or a path as sent to Hash.extract)
     */
    Json read(string myname = null) {
        if (_session.isNull) {
            return null;
        }
        if (myname.isNull) {
            return _session ?: [];
        }
        return Hash.get(_session, myname);
    } 
}
