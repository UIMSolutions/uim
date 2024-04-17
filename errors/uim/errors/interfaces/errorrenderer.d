module uim.errors.interfaces.errorrenderer;

import uim.errors;

@safe:

/**
 * Interface for D error rendering implementations
 *
 * The core provided implementations of this interface are used
 * by Debugger and ErrorTrap to render D errors.
 */
interface IErrorRenderer {
    /**
     * Render output for the provided error.
     * Params:
     * \UIM\Error\UimError error The error to be rendered.
     * @param bool shouldDebug Whether or not the application is in debug mode.
     * /
    string render(UimError error, bool shouldDebug);

    /**
     * Write output to the renderer`s output stream
     * Params:
     * string aout The content to output.
     * /
    void write(string aout);
    */
}
