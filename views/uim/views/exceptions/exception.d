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

    this
      .messageTemplate("Error in libary uim-views");

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
