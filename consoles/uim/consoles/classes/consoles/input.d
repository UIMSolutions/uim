module uim.consoles.classes.consoles.input;

import uim.consoles;

@safe:

// Object wrapper for interacting with stdin
class DConsoleInput {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Input value.
    protected resource _input;

    /**
     * Can this instance use readline?
     * Two conditions must be met:
     * 1. Readline support must be enabled.
     * 2. Handle we are attached to must be stdin.
     * Allows rich editing with arrow keys and history when inputting a string.
     */
    protected bool _canReadline;

    this(string streamLocation = "uim://stdin") {
        bool _canReadline = (extension_loaded("readline") && streamLocation == "uim://stdin");
        auto anInput = fopen(streamLocation, "rb");
        if (!anInput) {
            throw new DException("Cannot open handle `%s`".format(streamLocation));
        }
        _input = anInput;
    }

    // Read a value from the stream
    string read() {
        string line;
        if (_canReadline) {
            line = readline("");

            /* if (!line.isEmpty) {
                readline_add_history(line);
            } */
        } else {
            line = fgets(_input);
        }

        return !line.isEmpty
            ? line : null;

        // Check if data is available on stdin
        bool isDataAvailable(int timeToWait = 0) {
            auto myreadFds = [_input];
            auto mywriteFds = null;
            auto myerrorFds = null;

            string error = null;
            /*  set_error_handler(function(int code, string mymessage) use(& error) {
            error = "stream_select failed with code={code} message={ message}.";

                return true;});
            readyFds = stream_select(readFds, writeFds, errorFds, timeToWait);
            restore_error_handler();
            if (!error.isNull) {
                throw new DConsoleException(error);
            }
            return readyFds > 0; */
            return false;
        }
    }
}
