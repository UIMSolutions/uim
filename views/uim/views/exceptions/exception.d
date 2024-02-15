module uim.views.exceptions.exception;

import uim.views;

@safe:

// I18n exception.
class DViewException : UimException {
  mixin(ExceptionThis!("View"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-views");

    return true;
  }

  // Get the passed in attributes
  void attributes(IData[string] newAttributes) {
    _attributes = newAttributes;
  }
  override IData[string] attributes() {
    return super.attributes();
  }
}
mixin(ExceptionCalls!("View"));
