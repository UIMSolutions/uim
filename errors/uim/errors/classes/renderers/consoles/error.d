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
  mixin(ErrorRendererThis!("Console"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // `stderr` - The OutputConsole instance to use. Defaults to `D://stderr`
    // TODO _output = configuration.get("stderr", new DOutput("d://stderr"));
    // `trace` - Whether or not stacktraces should be output.       
    _showTrace = configuration.getBoolean("trace", false);

    return true;
  }

  // #region trace
  protected bool _showTrace = false;
  bool showTrace() {
    return _showTrace;
  }
  IErrorRenderer showTrace(bool value) {
    _showTrace = value;
    return this;
  }
  // #endregion trace

  // TODO protected DOutput _output;

  override IErrorRenderer write(string outputText) {
    writeln(outputText);
    return this;
  }

  override string render(IError error, bool shouldDebug) {
    return "<error>%s: %s . %s</error> on line %s of %s%s"
      .format(
        error.label(),
        error.code(),
        error.message(),
        error.line() ? error.line() : "",
        error.fileName() ? error.fileName() : "",
        showTrace ? "\n<info>Stack Trace:</info>\n\n" ~ error.traceAsString() : ""
      ); 
  }
}

unittest {
  auto renderer = new DConsoleErrorRenderer();
  assert(is(typeof(renderer) == IErrorRenderer));
  /* assert(renderer is DErrorRenderer);
  assert(renderer is DConsoleErrorRenderer); */

  auto error = new DError()
    .message("This is a test error")
    .code("TEST_ERROR")
    .fileName(__FILE__)
    .lineNumber(33);

  /* assert(renderer.render(new DError("Test Error", "TEST_ERROR", "This is a test error", __FILE__, __LINE__), true) == "<error>Test Error: TEST_ERROR . This is a test error</error> on line 33 of errors/uim/errors/classes/renderers/consoles/error.d\n<info>Stack Trace:</info>\n\n");
  assert(renderer.render(new DError("Test Error", "TEST_ERROR", "This is a test error", __FILE__, __LINE__), false) == "<error>Test Error: TEST_ERROR . This is a test error</error> on line 33 of errors/uim/errors/classes/renderers/consoles/error.d");
  assert(renderer.showTrace(true) is renderer);
  assert(renderer.showTrace() == true);
  assert(renderer.showTrace(false) is renderer);
  assert(renderer.showTrace() == false); */
}