/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.interfaces.errors.formatter;

import uim.errors;
@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

/******************************************************************************
 * Interface for formatters used by Debugger-
 *****************************************************************************/
interface IErrorFormatter {
    // Convert a tree of IErrorNode objects into a plain text string.
    string dump(IErrorNode node);

    /*************************************************************************
     * Output a dump wrapper with location context.
     * Params:
     * contentsToWrap = The contents to wrap and return
     * contentLocation = The file and line the contents came from.
     *************************************************************************/
    // TODO string formatWrapper(string contentsToWrap, Json contentLocation);
}
