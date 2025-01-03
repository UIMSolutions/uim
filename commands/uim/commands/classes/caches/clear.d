/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.caches.clear;

import uim.commands;

@safe:

// CacheClear command
class DCacheClearCommand : DCommand {
  mixin(CommandThis!("CacheClear"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  static string defaultName() {
    return "cache clear";
  }

  /**
     * Hook method for defining this command`s option parser.
     *
     * aDConsoleOptionParser buildOptionParser - The parser to be defined
     * returns - The built parser.
     */
  /* DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToBeDefined) {
    auto myParser = super.buildOptionParser(parserToBeDefined);
    myParser.description("Clear all data in a single cache engine");
    myParser.addArgument("engine", createMap!(string, Json)
        .set("help", "The cache engine to clear." ~
          "For example, `uim cache clear _uim_model_` will clear the model cache." ~
          " Use `uim cache list` to list available engines.")
        .set("required", true)
    );

    return myParser;
  } */

  // Implement this method with your command`s logic.
  override ulong execute(Json[string] arguments, IConsole aConsole = null) {
    string engineName = to!string(commandArguments.getArgument("engine"));
    try {
      aConsoleIo.writeln("Clearing {engineName}");

      auto engine = Cache.pool(engineName);
      Cache.clear(engineName);
      if (cast(DApcuEngine) engine) {
        aConsoleIo.warning("ApcuEngine detected: Cleared {engineName} CLI cache successfully " ~
            "but {engineName} web cache must be cleared separately.");
      } else {
        // aConsoleIo.out("<success>Cleared {engineName} cache</success>");
      }
    } catch (DInvalidArgumentException exception) {
      aConsoleIo.error(exception.message());
      this.abort();
    }
    return CODE_SUCCESS;
  }
}
