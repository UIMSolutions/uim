/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.interfaces.exceptionrenderer;

import uim.errors;

@safe:

interface IExceptionRenderer {
    // Renders the response for the exception.
    // TODO IResponse|string render();

    /**
     * Write the output to the output stream.
     *
     * This method is only called when exceptions are handled by a global default exception handler. */
    // TODO void write(IResponse | string outputResponse);
    // TODO void write(string outputResponse);
    // TODO void write(IResponse | string outputText);
    // TODO void write(string outputText);
}
