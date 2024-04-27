module uim.controllers.exceptions.missingcomponent;

import uim.controllers;

@safe:

// Used when a component cannot be found.
class DMissingComponentException : DControllersException {
  mixin(ExceptionThis!("MissingComponent"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Component class `%s` could not be found.");

    return true;
  }
}
mixin(ExceptionCalls!("MissingComponent"));
