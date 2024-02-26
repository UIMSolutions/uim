module uim.consoles.exceptions.missinghelper;

import uim.consoles;

@safe:

// Used when a Helper cannot be found.
class DMissingHelperException : DConsoleException {
  mixin(ExceptionThis!("MissingHelper"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Helper class '%s' could not be found.");
    // TODO .messageTemplate("Error in libary uim-commands");

    return true;
  }
}

mixin(ExceptionCalls!("MissingHelper"));
