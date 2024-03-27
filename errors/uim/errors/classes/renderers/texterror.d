module errors.uim.errors.classes.renderers.texterror;

import uim.errors;

@safe:

/** * Plain text error rendering with a stack trace.
 *
 * Useful in CLI environments.
 */
class DTextErrorRenderer { // }: IErrorRenderer {
    /* 
    void write(string aout) {
        writeln( result;
    }
 
    string render(UimError error, bool shouldDebug) {
        if (!debug) {
            return "";
        }
        return "%s: %s . %s on line %s of %s\nTrace:\n%s"
            .format(
                error.getLabel(),
                error.getCode(),
                error.getMessage(),
                error.getLine() ?? "",
                error.getFile() ?? "",
                error.getTraceAsString(),
            );
    } */
}
