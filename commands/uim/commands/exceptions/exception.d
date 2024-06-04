module uim.commands.exceptions.exception;

import uim.commands;

@safe:

// Base commands exception.
class DCommandsException : DException {
  mixin(ExceptionThis!("Commands"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-commands");

    return true;
  }
}
mixin(ExceptionCalls!("Commands"));
