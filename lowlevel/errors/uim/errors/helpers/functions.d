/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.helpers.functions;

import uim.errors;

@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

/**
 * Prints out debug information about given variable and returns the
 * variable that was passed.
 *
 * Only runs if debug mode is enabled.
 */
Json debugInfo(Json debugVariable, bool showHtml = false, bool showFrom = true) {
    /* if (!configuration.hasEntry("debug")) {
        return debugVariable;
    } */

    /* 
    auto location = null;
    if (showFrom) {
        trace = Debugger.trace(["start": 0, "depth": 1, "format": "array"]);
        if (isSet(trace[0]["line"]) && isSet(trace[0]["file"])) {
            location = [
                "line": trace[0]["line"],
                "file": trace[0]["file"],
            ];
        }
    }
    Debugger.printVar(debugVariable, location, showHtml);
    */
    // return debugVariable;
    return Json(null);
}
/**
 * Outputs a stack trace based on the supplied options.
 *
 * ### Options
 *
 * - `depth` - The number of stack frames to return. Defaults to 999
 * - `args` - Should arguments for functions be shown? If true, the arguments for each method call
 * will be displayed.
 * - `start` - The stack frame to start generating a trace from. Defaults to 1
 */
void stackTrace(Json[string] options = new Json[string]) {
    /* if (!configuration.hasEntry("debug")) {
        return;
    } */

    options
        .merge("start", 0)
        .set("start", options.getLong("start") + 1);

    /* string trace = Debugger.trace(formatOptions);
    writeln(trace); */
}
/**
 * Prints out debug information about given variable and dies.
 *
 * Only runs if debug mode is enabled.
 * It will otherwise just continue code execution and ignore this function.
 */
void dd(Json varForDebugInfo, bool showHtml = false) {
   /*  if (!configuration.hasEntry("debug")) {
        return;
    }

    auto trace = Debugger.trace(MapHelper.create!(string, Json)
            .set("start", 0)
            .set("depth", 2)
            .set("format", "array"));

    auto location = MapHelper.create!(string, Json)
        .set("line", trace[0]["line"])
        .set("file", trace[0]["file"]);

    Debugger.printVar(varForDebugInfo, location, showHtml);
    die(1); */
}
