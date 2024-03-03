module uim.commands.caches.cachelist;

import uim.commands;

@safe:

// CacheList command.
class CacheListCommand : Command {
  mixin(CommandThis!("CacheList"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(configData)) { return false; }
		
		return true;
	}

  static string defaultName() {
    return "cache list";
  }

  // Hook method for defining this command`s option parser.
  ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToBeDefined) {
    auto myParser = super.buildOptionParser(parserToBeDefinedr);
    myParser.description("Show a list of configured caches.");

    return myParser;
  }

  // Get the list of cache prefixes
  int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
    auto myEngines = Cache.configured();
    myEngines
      .each!(engine => aConsoleIo.writeln("- %s".format(engine)));

    return CODE_SUCCESS;
  }
}
