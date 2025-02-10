/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.renderers.consoles.error;

import uim.errors;
@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

/*
 * Plain text error rendering with a stack trace.
 * Writes to STDERR via a UIM\Console\OutputConsole instance for console environments
 */
class DConsoleErrorRenderer : DErrorRenderer { 
  protected bool _trace = false;

 /*  protected DOutput _output; */

  this(Json[string] initData = null) {
    // initialize(initData);
    // `stderr` - The OutputConsole instance to use. Defaults to `D://stderr`
    // `trace` - Whether or not stacktraces should be output.       _output = configuration.get("stderr", new DOutput("d://stderr"));
    // _trace = configuration.getBoolean("trace", false);
  }

  override IErrorRenderer write(string outputText) {
    writeln(outputText);
    return this;
  }

  override string render(IError error, bool shouldDebug) {
    string trace = "";
   /*  if (this.trace) {
      trace = "\n<info>Stack Trace:</info>\n\n" ~ error.traceAsString();
    }
    return "<error>%s: %s . %s</error> on line %s of %s%s"
      .format(
        error.label(),
        error.code(),
        error.message(),
        error.line() ? error.line() : "",
        error.fileName() ? error.fileName() : "",
        trace
      ); */
      return null; 
  }
}
