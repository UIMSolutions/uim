module uim.oop.tests.constraints.session.flashparamequals;

import uim.oop;

@safe:

/**
 * FlashParamEquals
 *
 * @internal
 */
class DFlashParamEquals : Constraint {
    protected ISession session;

    protected string aKey;

    protected string aparam;

    protected int at = null;

    /**
     * Constructor
     * Params:
     * \UIM\Http\Session|null session Session
     * @param string aKey Flash key
     * @param string aparam Param to check
     * @param int at Expected index
     * /
    this(ISession session, string aKey, string aparam, int at = null) {
        if (!session) {
            string message = "There is no stored session data. Perhaps you need to run a request?";
            message ~= " Additionally, ensure `this.enableRetainFlashMessages()` has been enabled for the test.";
            throw new AssertionFailedError(message);
        }
        this.session = session;
        this.key = aKey;
        this.param = param;
        this.at = at;
    }
    
    /**
     * Compare to flash message(s)
     * Params:
     * IData other Value to compare with
     * /
   bool matches(IData expectedOther) {
        // Server.run calls Session.close at the end of the request.
        // Which means, that we cannot use Session object here to access the session data.
        // Call to Session.read will start new session (and will erase the data).
        /** @psalm-suppress InvalidScalarArgument * /
        messages = (array)Hash.get(_SESSION, "Flash." ~ this.key);
        if (this.at) {
            /** @psalm-suppress InvalidScalarArgument * /
            messages = [Hash.get(_SESSION, "Flash." ~ this.key ~ "." ~ this.at)];
        }
        foreach (message; messages) {
            if (!message.isSet(this.param)) {
                continue;
            }
            if (message[this.param] == other) {
                return true;
            }
        }
        return false;
    }
    
    // Assertion message string
    override string toString() {
        if (!this.at is null) {
            return "is in \"%s\" %s #%d".format(this.key, this.param, this.at);
        }
        return "is in \"%s\" %s".format(this.key, this.param);
    } */
}
