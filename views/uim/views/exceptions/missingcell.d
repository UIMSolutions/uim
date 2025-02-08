/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.exceptions.missingcell;

import uim.views;

@safe:

// Used when a cell class file cannot be found.
class DMissingCellException : DViewException {
  mixin(ExceptionThis!("MissingCell"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Cell class %s is missing.");

    return true;
  }
}

mixin(ExceptionCalls!("MissingCell"));
