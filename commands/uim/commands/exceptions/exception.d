/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module commands.uim.commands.exceptions.exception;

import uim.commands;

@safe:

// Base commands exception.
class DCommandsException : UIMException {
  mixin(ExceptionThis!("Commands"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-commands");

    return true;
  }
}

mixin(ExceptionCalls!("Commands"));

unittest {
  testException(CommandsException);
}
