/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.renderers.texts.error;

import uim.errors;

@safe:

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * Plain text error rendering with a stack trace.
 * Useful in CLI environments.
 */
class DTextErrorRenderer : DErrorRenderer {
  mixin(ErrorRendererThis!("Text"));

  // Hook method
  /* override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  } */

  override void write(string outputText) {
    writeln(outputText);
  }

  string render(IError error, bool isDebug) {
    if (!isDebug) { return null; }

    // isDebug
    return 
      "%s: %s . %s on line %s of %s\nTrace:\n%s".format(
        error.label(),
        error.code(),
        error.message(),
        error.line() ? error.line() : "",
        error.fileName() ? error.fileName() : "",
        error.traceAsString());
  }
}
mixin(ErrorRendererCalls!("Text"));

unittest {
  assert(TextErrorRenderer);
}
