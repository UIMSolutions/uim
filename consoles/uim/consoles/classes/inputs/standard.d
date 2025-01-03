/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.inputs.standard;

import uim.consoles;

@safe:

// Object wrapper for interacting with stdin
class DStandardInput : DInput {
  mixin(InputThis!("Standard"));

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
  override string read() {
    string line;
    if (_canReadline) {
      /* line = readline(""); */

      /* if (!line.isEmpty) {
                readline_add_history(line);
            } */
    } else {
      /* line = fgets(_input); */
    }

    return !line.isEmpty
      ? line : null;
  }

  // Check if data is available on stdin
  bool isDataAvailable(int timeToWait = 0) {
    auto myreadFds = [_input];
    auto mywriteFds = null;
    auto myerrorFds = null;

    string error = null;
    /* set_error_handler(function(int code, string mymessage) use(& error) {
            error = "stream_select failed with code={code} message={ message}.";

                return true;});
            readyFds = stream_select(readFds, writeFds, errorFds, timeToWait);
            restore_error_handler();
            if (!error.isNull) {
                throw new DConsoleException(error);
            }
            return readyFds > 0; */
    return false;
  }
}
