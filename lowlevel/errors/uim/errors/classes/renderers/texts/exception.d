/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.renderers.texts.exception;

import uim.errors;

@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

/**
 * Plain text exception rendering with a stack trace.
 * Useful in CI or plain text environments.
 */
class DTextExceptionRenderer : IExceptionRenderer{
  private IError _error;

  this(IError error) {
    _error = error;
  }

  // Render an exception into a plain text message.
  string render() {
    return "%s : %s on line %s of %s\nTrace:\n%s".format(
      _error.code(),
      _error.message(),
      _error.line(),
      _error.fileName(),
      _error.traceAsString(),
    );
    return null; // TODO
  }

  // Write output to stdout.
  IExceptionRenderer write(string outputText) {
    writeln(outputText);
    return this;
  }
}
