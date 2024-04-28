module uim.consoles.exceptions.missinghelper;

import uim.consoles;

@safe:

// Used when a Helper cannot be found.
class DMissingHelperException : DConsoleException {
  mixin(ExceptionThis!("MissingHelper"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Helper class '%s' could not be found.");
    // TODO .messageTemplate("Error in libary uim-commands");

    return true;
  }
}

mixin(ExceptionCalls!("MissingHelper"));
