module uim.controllers.exceptions.missingaction;

import uim.controllers;

@safe:

// Missing Action exception - used when a controller action
// cannot be found, or when the controller`s isAction() method returns false.
class DMissingActionException : DControllersException {
  mixin(ExceptionThis!("MissingAction"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Action `%s.%s()` could not be found, or is not accessible.");

    return true;
  }
}

mixin(ExceptionCalls!("MissingAction"));
