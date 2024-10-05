/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.gui.exceptions.exception;UIMException

import uim.gui;

@safe:

// I18n exception.
class DGuiException : DException {
  mixin(ExceptionThis!("Gui"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-gui");

    return true;
  }
}
mixin(ExceptionCalls!("Gui"));
