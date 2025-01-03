/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.caches.list;

import uim.commands;

@safe:

// CacheList command.
class DCacheListCommand : DCommand {
  mixin(CommandThis!("CacheList"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    
    return true;
  }

  static string defaultName() {
    return "cache list";
  }

  // Hook method for defining this command`s option parser.
  /* 
  DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToBeDefined) {
    auto myParser = super.buildOptionParser(parserToBeDefinedr);
    myParser.description("Show a list of configured caches.");

    return myParser;
  }

  // Get the list of cache prefixes
  override ulong execute(Json[string] arguments, IConsole console = null) {
    auto myEngines = Cache.configured();
    myEngines
      .each!(engine => aConsoleIo.writeln("- %s".format(engine)));

    return CODE_SUCCESS;
  } */
}
