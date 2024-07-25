module uim.commands.classes.commands.schemacaches.clear;

import uim.commands;

@safe:

// Provides CLI tool for clearing schema cache.
class DSchemacacheClearCommand : DCommand {
   mixin(CommandThis!("SchemacacheClear"));

  	override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

  // Get the command name.
  static string defaultName() {
    return "schema_cache-clear";
  }
  
    override override ulong execute(Json[string] arguments, IConsole aConsole = null) {
    return super.execute(arguments, aConsoleIo);
  }

  /* 

  // Display all routes in an application
  override ulong execute(Json[string] arguments, IConsole aConsole = null) {
    try {
      aConnection = ConnectionManager . get(to!string(commandArguments.getOption("connection")));
      assert(cast(Connection)aConnection);

      cache = new DSchemaCache(aConnection);
    } catch (RuntimeException anException) {
      aConsoleIo.error(anException.message());

      return CODE_ERROR;
    }
    
    auto tables = cache.clear(commandArguments.getArgument("name"));
    tables.each!(table => aConsoleIo.verbose("Cleared `%s`".format(aTable)));
    aConsoleio.out ("<success>Cache clear complete</success>");

    return CODE_SUCCESS;
  }

  // Get the option parser.
  DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
    parserToUpdate.description(
      "Clear all metadata caches for the connection. If a table name is provided, only that table will be removed."
   )
      .addOption("connection", [
          "help": "The connection to build/clear metadata cache data for.",
          "short": "c",
          "default": "default",
        ]).addArgument("name", [
          "help": "A specific table you want to clear cached data for.",
          "required": false.toJson,
        ]);

    return parserToUpdate;
  } */
}
