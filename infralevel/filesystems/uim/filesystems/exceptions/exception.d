/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.exceptions.exception;

mixin(Version!"test_uim_filesystems");

import uim.filesystems;
@safe:

// I18n exception.
class DFilesystemsException : DException {
  mixin(ExceptionThis!("Filesystems"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Exception in libary uim-filesystems");

    return true;
  }
}

mixin(ExceptionCalls!("Filesystems"));

unittest {
  assert(FilesystemsException);
}
