module uim.commands.exceptions.exception;

import uim.commands;

@safe:

// Base commands exception.
class DCommandsException : UimException {
  mixin(ExceptionThis!("Commands"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-commands");

    return true;
  }
}
mixin(ExceptionCalls!("Commands"));
