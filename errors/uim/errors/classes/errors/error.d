module uim.errors.classes.errors.error;

import uim.errors;

@safe:

class UIMError : IError {
    this() {

    }

    ERRORS code() {
        return ERRORS.ERROR;
    }

    void message(string message) {

    }

    string message() {
        return null;
    }

    string fileName() {
        return null;
    }

    size_t lineNumber() {
        return 0;
    }

    size_t[string][] trace() {
        return null;
    }
}
