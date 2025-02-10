/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.exceptions.exception;

import uim.views;

@safe:

// I18n exception.
class DViewException : DException {
  mixin(ExceptionThis!("View"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-views");

    return true;
  }

  // Get the passed in attributes
  override void attributes(Json[string] newAttributes) {
    _attributes = newAttributes;
  }

  override Json[string] attributes() {
    return super.attributes();
  }
}

mixin(ExceptionCalls!("View"));
