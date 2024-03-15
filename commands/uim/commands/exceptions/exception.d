module commands.uim.commands.exceptions.exception;

import uim.commands;

@safe:

// Base commands exception.
class DCommandsException : UimException {
  mixin(ExceptionThis!("Commands"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-commands");

    return true;
  }
}
mixin(ExceptionCalls!("Commands"));
