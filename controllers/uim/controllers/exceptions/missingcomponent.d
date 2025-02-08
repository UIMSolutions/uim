/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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

unittest {
  assert(MissingComponentException);
}
