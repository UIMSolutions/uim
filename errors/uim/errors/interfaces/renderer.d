module uim.errors.interfaces.errorrenderer;

import uim.errors;

@safe:

/**
 * Interface for UIM error rendering implementations
 *
 * The core provided implementations of this interface are used
 * by Debugger and ErrorTrap to render UIM errors.
 */
interface IErrorRenderer {
    // Render output for the provided error.
    string render(UIMError errorToRender, bool shouldDebug);

    /**
     * Write output to the renderer`s output stream
     * Params:
     * string aout The content to output.
     */
    void write(string aout);
}
