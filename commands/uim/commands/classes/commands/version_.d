/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.version_;

import uim.commands;

@safe:

// Print out the version of UIM in use.
class DVersionCommand : DCommand {
  mixin(CommandThis!("Version"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  override ulong execute(Json[string] arguments, IConsole aConsole = null) {
    //TODO aConsoleIo.writeln(Configure.currentVersion());

    return 0; //TODO CODE_SUCCESS;
  }
}
mixin(CommandCalls!("Version"));
