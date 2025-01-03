/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.inputs.input;

import uim.consoles;

@safe:

// Object wrapper for interacting with stdin
class DInput : UIMObject, IInput {
  mixin(InputThis!());

  // Input value.
  protected UIMObject _input;

  /**
     * Can this instance use readline?
     * Two conditions must be met:
     * 1. Readline support must be enabled.
     * 2. Handle we are attached to must be stdin.
     * Allows rich editing with arrow keys and history when inputting a string.
     */
  protected bool _canReadline;

  // Read a value from the stream
  string read() {
    return null;
  }

  // Check if data is available on stdin
  bool isDataAvailable(int timeToWait = 0) {
    return false;
  }
}
