module uim.errors.helpers.functions;

//Dcs:disable PSR1.Files.SideEffectsmodule uim.errors;


/**
 * Prints out debug information about given variable and returns the
 * variable that was passed.
 *
 * Only runs if debug mode is enabled.
 *
 * @param IData var Variable to show debug information for.
 * @param bool|null showHtml If set to true, the method prints the debug data in a browser-friendly way.
 * @param bool showFrom If set to true, the method prints from where the auto was called.
 * /
IData debug(IData var, bool showHtml = null, bool showFrom = true):  
{
    if (!Configure.read("debug")) {
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
    Debugger.printVar(var, location, showHtml);

    return var;
}
/**
 * Outputs a stack trace based on the supplied options.
 *
 * ### Options
 *
 * - `depth` - The number of stack frames to return. Defaults to 999
 * - `args` - Should arguments for functions be shown? If true, the arguments for each method call
 *  will be displayed.
 * - `start` - The stack frame to start generating a trace from. Defaults to 1
 *
 * @param IData[string] options Format for outputting stack trace
 * /
void stackTrace(IData[string] options = null) {
    if (!Configure.read("debug")) {
        return;
    }
    options = options.update["start": 0];
    options["start"]++;

    /** @var string atrace * /
    trace = Debugger.trace(options);
    writeln(trace);
}
/**
 * Prints out debug information about given variable and dies.
 *
 * Only runs if debug mode is enabled.
 * It will otherwise just continue code execution and ignore this function.
 *
 * @param IData var Variable to show debug information for.
 * @param bool|null showHtml If set to true, the method prints the debug data in a browser-friendly way.
 * /
void dd(IData var, ?bool showHtml = null) {
    if (!Configure.read("debug")) {
        return;
    }
    trace = Debugger.trace(["start": 0, "depth": 2, "format": 'array"]);
    /** @psalm-suppress PossiblyInvalidArrayOffset * /
    location = [
        'line": trace[0]["line"],
        'file": trace[0]["file"],
    ];

    Debugger.printVar(var, location, showHtml);
    die(1);
}
*/