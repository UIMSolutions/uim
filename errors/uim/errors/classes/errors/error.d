module uim.errors.classes.errors.error;

import uim.errors;

@safe:

class UIMError : IError {
    this() {

    }

    ERRORS code();

    void message(string message);
    string message();

    string fileName();

    size_t lineNumber();

    size_t[string][] trace();

}
