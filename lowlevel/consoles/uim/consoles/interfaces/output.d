/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.interfaces.output;

import uim.consoles;

@safe:

interface IOutput : IObject {
    // Outputs a single or multiple messages or newlines to stdout / stderr.
    IOutput write(uint numberOfLines = 1);
    IOutput write(string[] messages, uint numberOfLines = 1);
    IOutput write(string message, uint numberOfLines = 1);

    // #region style
    // Gets the current styles offered
    Json style(string name);
    // Gets all the style definitions.
    Json[string] styles();

    // Set style
    IOutput style(string style, STRINGAA definition);
    IOutput style(string style, Json definition);
    IOutput removeStyle(string name);
    // #endregion style

    // #region outputType
    // Get the output type on how formatting tags are treated.
    string outputType();
    // Set the output type on how formatting tags are treated.
    IOutput outputType(string type);
    // #endregion outputType
}
