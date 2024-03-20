module uim.cake.TestSuite\Constraint\Session;

import uim.cake;

@safe:

/**
 * SessionEquals
 *
 * @internal
 */
class SessionEquals : Constraint {
    protected string aPath;

    /**
     * Constructor
     * Params:
     * string aPath Session Path
     */
    this(string aPath) {
        this.path = somePath;
    }
    
    /**
     * Compare session value
     * Params:
     * Json other Value to compare with
     */
   bool matches(Json expectedOther) {
        // Server.run calls Session.close at the end of the request.
        // Which means, that we cannot use Session object here to access the session data.
        // Call to Session.read will start new session (and will erase the data).
        /** @psalm-suppress InvalidScalarArgument */
        return Hash.get(_SESSION, this.path) == other;
    }
    
    // Assertion message
    override string toString() {
        return "is in session path \"%s\"".format(this.path);
    }
}
