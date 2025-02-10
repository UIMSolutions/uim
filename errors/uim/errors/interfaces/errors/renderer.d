/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.interfaces.errors.renderer;

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
    string render(IError errorToRender, bool shouldDebug);

    // Write output to the renderer`s output stream
    IErrorRenderer write(string output);
}
