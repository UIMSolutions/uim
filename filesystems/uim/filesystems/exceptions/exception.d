module uim.filesystems.exceptions.exception;

import uim.filesystems;

@safe:

// I18n exception.
class DFilesystemsException : UimException {
  mixin(ExceptionThis!("Filesystems"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .messageTemplate("Error in libary uim-filesystems");

    return true;
  }
}
mixin(ExceptionCalls!("Filesystems"));
