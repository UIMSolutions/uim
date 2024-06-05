/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.errors.classes.errors.error;

@safe:
import uim.errors;

// Error base class for UIM applications
class DError {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        // TODO
        /*
        levelMap = [
            E_PARSE: "error",
            E_ERROR: "error",
            E_CORE_ERROR: "error",
            E_COMPILE_ERROR: "error",
            E_USER_ERROR: "error",
            E_WARNING: "warning",
            E_USER_WARNING: "warning",
            E_COMPILE_WARNING: "warning",
            E_RECOVERABLE_ERROR: "warning",
            E_NOTICE: "notice",
            E_USER_NOTICE: "notice",
            E_STRICT: "strict",
            E_DEPRECATED: "deprecated",
            E_USER_DEPRECATED: "deprecated",
        ]; */

        // TODO
        /* _logMap = [
            "error": LOG_ERR,
            "warning": LOG_WARNING,
            "notice": LOG_NOTICE,
            "strict": LOG_NOTICE,
            "deprecated": LOG_NOTICE,
        ]; */

        return true;
    }

    mixin(TProperty!("string", "name"));

    mixin(OProperty!("int", "code"));

    mixin(OProperty!("string", "message"));

    mixin(OProperty!("string", "filename"));

    mixin(OProperty!("int", "lineNumber"));

    mixin(OProperty!("int[string][]", "trace"));

    protected string[int] _levelMap;

    private int[string] _logMap;

    /*
    this(
        int newErrorCode,
        string newErrorMessage,
        string newErrorFilename = "",
        int newLineNumber = 0,
        int[string][] traceData = null
   ) {
        this.code(newErrorCode);
        this.message(newErrorMessage);
        this.filename(newErrorFilename);
        this.lineNumber(newLineNumber);
        this.trace(traceData);
    }

    // Get the mapped LOG_ constant.
    int getLogLevel() {
        auto myLabel = label();

        return _logMap.get(myLabel, 0); // TODO LOG_ERR);
    }

    // Get the error code label
    string label() {
        return _levelMap.get(code, "error");
    }

    // Get the stacktrace as a string.
    string getTraceAsString() {
        return _trace.map!(entry =>
                `{frame["reference"]} {frame["file"]}, line {frame["line"]}`)
            .join("\n"); // TODOD
    } */
}
