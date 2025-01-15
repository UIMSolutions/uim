/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.renderers.texts.exception;

@safe:
import uim.errors;

// s

/**
 * Plain text exception rendering with a stack trace.
 *
 * Useful in CI or plain text environments.
 *
 * @todo 5.0 Implement uim.errors.IExceptionRenderer. This implementation can"t implement
 * the concrete interface because the return types are not compatible.
 */
class DTextExceptionRenderer {
    private Throwable _error;

    this(Throwable errorToRender) {
        _error = error;
    }

    // Render an exception into a plain text message.
    string render() {
/*         return "%s : %s on line %s of %s\nTrace:\n%s".format(
            _error.code(),
            _error.message(),
            _error.line(),
            _error.getFile(),
            _error.getTraceAsString(),
       ); */
       return null; // TODO
    }

    // Write output to stdout.
    void write(string outputText) {
        writeln(outputText);
    }
}
