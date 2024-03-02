module uim.cake.commands.caches.cacheclear;

import uim.cake;

@safe:

// CacheClear command.
class CacheClearCommand : Command {
  mixin!(CommandThis!("CacheClearCommand"));

  	override bool initialize(IConfigData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
		return true;
	}

  static string defaultName() {
    return "cache clear";
  }

  /**
     * Hook method for defining this command`s option parser.
     *
     * @see https://book.UIM.org/5/en/console-commands/option-parsers.html
     * aConsoleOptionParser - The parser to be defined
     * returns - The built parser.
     */
  ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToBeDefined) {
    auto myParser = super.buildOptionParser(parserToBeDefined);
    myParser.description("Clear all data in a single cache engine");
    myParser.addArgument("engine", [
        "help": "The cache engine to clear." ~
        "For example, `cake cache clear _cake_model_` will clear the model cache." ~
        " Use `cake cache list` to list available engines.",
        "required": true,
      ]);

    return myParser;
  }

  // Implement this method with your command`s logic.
  int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
    name = to!string( commandArguments.getArgument("engine"));
    try {
      aConsoleIo.writeln("Clearing {name}");

      engine = Cache.pool(name);
      Cache.clear(name);
      if (cast(ApcuEngine)$engine) {
        aConsoleIo.warning("ApcuEngine detected: Cleared {name} CLI cache successfully " ~
            "but {name} web cache must be cleared separately.");
      } else {
        aConsoleIo.
        out ("<success>Cleared {name} cache</success>");
      }
    }
 catch (InvalidArgumentException anException) {
      aConsoleIo.error(anException.getMessage());
      this.abort();
    }
    return CODE_SUCCESS;
  }
}
