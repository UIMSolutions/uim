module uim.filesystems.exceptions.exception;

import uim.filesystems;

@safe:

// I18n exception.
class DFSException : UimException {
  mixin(ExceptionThis!("FS"));

  override bool initialize() {
    if (!super.initialize()) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-filesystems");

    return true;
  }
}
mixin(ExceptionCalls!("FS"));
