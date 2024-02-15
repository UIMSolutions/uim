module uim.filesystems.exceptions.exception;

import uim.filesystems;

@safe:

// I18n exception.
class DFilesystemException : UimException {
  mixin(ExceptionThis!("Filesystem"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .messageTemplate("Error in libary uim-filesystems");

    return true;
  }
}
mixin(ExceptionCalls!("Filesystem"));
