/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.gui.exceptions.exception;

import uim.gui;

@safe:

// I18n exception.
class DGuiException : UIMException {
  mixin(ExceptionThis!("Gui"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-gui");

    return true;
  }
}

mixin(ExceptionCalls!("Gui"));

unittest {
  testException(GuiException);
}
