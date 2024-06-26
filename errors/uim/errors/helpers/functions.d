module uim.errors.helpers.functions;

import uim.errors;
@safe:

/**
 * Prints out debug information about given variable and returns the
 * variable that was passed.
 *
 * Only runs if debug mode is enabled.
 */
Json debug(Json debugVariable, bool showHtml = null, bool showFrom = true):  
{
    if (!configuration.hasKey("debug")) {
        return var;
    }
    location = null;
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

    return debugVariable;
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
void stackTrace(Json[string] formatOptions = null) {
    if (!configuration.hasKey("debug")) {
        return;
    }
    auto updatedOptions = formatOptions.update["start": 0];
    formatOptions["start"]++;

    /** @var string atrace */
    trace = Debugger.trace(formatOptions);
    writeln(trace);
}
/**
 * Prints out debug information about given variable and dies.
 *
 * Only runs if debug mode is enabled.
 * It will otherwise just continue code execution and ignore this function.
 */
void dd(Json varForDebugInfo, bool showHtml = null) {
    if (!configuration.hasKey("debug")) {
        return;
    }

    auto trace = Debugger.trace(["start": 0.toJson, "depth": 2.toJson, "format": "array".toJson]);
    auto location = [
        "line": trace[0]["line"],
        "file": trace[0]["file"],
    ];

    Debugger.printVar(varForDebugInfo, location, showHtml);
    die(1);
}