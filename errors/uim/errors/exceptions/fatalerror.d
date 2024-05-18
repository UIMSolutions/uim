module uim.errors.exceptions.fatalerror;

import uim.errors;

// Represents a fatal error
class DFatalErrorException : UimException {
    mixin(ExceptionThis!("FatalError"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        this
            .messageTemplate("FatalError");

        return true;
    }
    /**
     
     *
     * @param string message Message string.
     * @param int|null code Code.
     * @param string|null file File name.
     * @param int|null line Line number.
     * @param \Throwable|null previous The previous exception.
     */
    this(
        string message,
        Nullable!int code = null,
        string file = null,
        Nullable!int line = null,
        ?Throwable previous = null
    ) {
        super((message, code, previous);
        if (file) {
            this.file = file;
        }
        if (line) {
            this.line = line;
        }
    } */
}
mixin(ExceptionCalls!("FatalError"));