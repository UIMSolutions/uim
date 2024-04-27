module uim.commands.classes.commands.caches.list;

import uim.commands;

@safe:

// CacheList command.
class DCacheListCommand : DCommand {
  mixin(CommandThis!("CacheList"));

  	override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

  static string defaultName() {
    return "cache list";
  }

  // Hook method for defining this command`s option parser.
  /* 
  DConsoleOptionParser buildOptionParser(DConsoleOptionParser buildOptionParser parserToBeDefined) {
    auto myParser = super.buildOptionParser(parserToBeDefinedr);
    myParser.description("Show a list of configured caches.");

    return myParser;
  }

  // Get the list of cache prefixes
  int execute(Json[string] arguments, IConsoleIo aConsoleIo) {
    auto myEngines = Cache.configured();
    myEngines
      .each!(engine => aConsoleIo.writeln("- %s".format(engine)));

    return CODE_SUCCESS;
  } */
}
