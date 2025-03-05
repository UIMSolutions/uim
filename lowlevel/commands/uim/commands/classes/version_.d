/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.version_;

import uim.commands;
@safe:

version (test_uim_commands) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// Print out the version of UIM in use.
class DVersionCommand : DCommand {
  mixin(CommandThis!("Version"));

  override bool execute(Json[string] arguments, IConsole console = null) {
// TODO    console.writeln(Configure.currentVersion());

    return true;
  }
}
mixin(CommandCalls!("Version"));
