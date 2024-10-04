/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.renderers.consoles.error;

import uim.errors;

@safe:

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

/*
 * Plain text error rendering with a stack trace.
 * Writes to STDERR via a UIM\Console\ConsoleOutput instance for console environments
 */
class DConsoleErrorRenderer { // }: IErrorRenderer {
  protected bool _trace = false;

  protected DConsoleOutput _output;

  this(Json[string] initData = null) {
    initialize(initData);
    // `stderr` - The ConsoleOutput instance to use. Defaults to `D://stderr`
    // `trace` - Whether or not stacktraces should be output.       _output = configuration.get("stderr", new DConsoleOutput("d://stderr"));
    _trace = configuration.getBoolean("trace", false);
  }

  void write(string outputText) {
    _output.write(outputText);
  }

  string render(UIMError error, bool shouldDebug) {
    string trace = "";
    if (this.trace) {
      trace = "\n<info>Stack Trace:</info>\n\n" ~ error.getTraceAsString();
    }
    return "<error>%s: %s . %s</error> on line %s of %s%s"
      .format(
        error.getLabel(),
        error.code(),
        error.message(),
        error.getLine() ? error.getLine() : "",
        error.getFile() ? error.getFile() : "",
        trace
      );
  }
}
