/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.renderers.error;

import uim.errors;

@safe:

class DErrorRenderer : UIMObject, IErrorRenderer {
    mixin(ErrorRendererThis!());

    // Render output for the provided error.
    string render(IError error, bool shouldDebug) {
        return null; 
    }

    // Write output to the renderer`s output stream
    void write(string output) {}
}
