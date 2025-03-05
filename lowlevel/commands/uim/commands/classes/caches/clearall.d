/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.caches.clearall;

import uim.commands;
@safe:

version (test_uim_commands) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// CacheClearall command.
class DCacheClearallCommand : DCommand {
  mixin(CommandThis!("CacheClearall"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // Get the command name.
  static string defaultName() {
    return "cache clear_all";
  }

  // Hook method for defining this command`s option parser.
  /* DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToBeDefined) {
    auto result = super.buildOptionParser(parserToBeDefined);
    result.description("Clear all data in all configured cache engines.");

    return result;
  }

  // Implement this method with your command`s logic.
  override bool execute(Json[string] arguments, IConsole console = null) {
    auto myEngines = Cache.configured();
    // myEngines.each!(engine => this.executeCommand(CacheClearCommand.class, [engine], aConsole));

    return true;
  } */
}
