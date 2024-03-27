/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.classes.error;

@safe:
import uim.errors;

// Error base class for UIM applications
class DError {
      mixin TConfigurable!();

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

mixin(OProperty!("int", "code"));

  mixin(OProperty!("string", "message"));

  mixin(OProperty!("string", "file"));

  mixin(OProperty!("int", "line"));

  mixin(OProperty!("int[string][]", "trace"));

  /* 
  private string[int] levelMap = [
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
  ];

  private int[string] _logMap = [
      "error": LOG_ERR,
      "warning": LOG_WARNING,
      "notice": LOG_NOTICE,
      "strict": LOG_NOTICE,
      "deprecated": LOG_NOTICE,
  ];

    /**
     * Constructor
     *
     * @param int code The PHP error code constant
     * @param string message The error message.
     * @param string|null file The filename of the error.
     * @param int|null line The line number for the error.
     * @param array trace The backtrace for the error.
     * /
    this(
        int aCode,
        string aMessage,
        string aFile = "",
        int aLine = 0,
        int[string][] traceData = null
    ) {
        this
          .code(aCode)
          .message(aMessage)
          .file(aFile)
          .line(aLine)
          .trace(traceData);
    }


    // Get the mapped LOG_ constant.
    int getLogLevel() {
        label = this.getLabel();

        return this.logMap.get(label, LOG_ERR);
    }

    // Get the error code label
    string label() {
      return this.levelMap.get(this.code, "error");
    }

    // Get the stacktrace as a string.
    string getTraceAsString() {
      string[] results;
      foreach (traceEntry; this.trace) {
          out ~= "{frame["reference"]} {frame["file"]}, line {frame["line"]}";
      }

      return results.join("\n");
    } */
}
