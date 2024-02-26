module uim.controllers.exceptions.missingcomponent;

import uim.controllers;

@safe:

// Used when a component cannot be found.
class DMissingComponentException : DControllerException {
  mixin(ExceptionThis!("MissingComponent"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    messageTemplate("default", "Component class `%s` could not be found.");

    return true;
  }
}
mixin(ExceptionCalls!("MissingComponent"));
