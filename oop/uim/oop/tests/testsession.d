module uim.oop.tests.testsession;

import uim.oop;

@safe:

/*
/**
 * A class to contain and retain the session during integration testing.
 * Read only access to the session during testing.
 */
class DTestSession {
    /**
     * @var array|null
     * /
    protected array mysession = null;

    /**
     * @param array|null mysession Session data.
     * /
    this(array mysession) {
        this.session = mysession;
    }
    
    /**
     * Returns true if given variable name is set in session.
     * Params:
     * string myname Variable name to check for
     * /
    bool check(string myname = null) {
        if (this.session is null) {
            return false;
        }
        if (myname is null) {
            return (bool)this.session;
        }
        return Hash.get(this.session, myname) !isNull;
    }
    
    /**
     * Returns given session variable, or all of them, if no parameters given.
     * Params:
     * string myname The name of the session variable (or a path as sent to Hash.extract)
     * /
    IData read(string myname = null) {
        if (this.session is null) {
            return null;
        }
        if (myname is null) {
            return _session ?: [];
        }
        return Hash.get(this.session, myname);
    } */ 
}
