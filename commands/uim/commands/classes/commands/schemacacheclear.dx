module uim.commands.schemacacheclear;

import uim.commands;

@safe:

// Provides CLI tool for clearing schema cache.
class SchemacacheClearCommand : Command {
   mixin(CommandThis!("SchemacacheClearCommand"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

  // Get the command name.
  static string defaultName() {
    return "schema_cache clear";
  }

  // Display all routes in an application
  int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
    try {
      aConnection = ConnectionManager . get(to!string(commandArguments.getOption("connection")));
      assert(cast8Connection)aConnection);

      cache = new SchemaCache(aConnection);
    } catch (RuntimeException anException) {
      aConsoleIo.error(anException.getMessage());

      return CODE_ERROR;
    }
    
    auto tables = cache.clear(commandArguments.getArgument("name"));
    tables.each!(table => aConsoleIo.verbose("Cleared `%s`".format(aTable)));
    aConsoleio.out ("<success>Cache clear complete</success>");

    return CODE_SUCCESS;
  }

  /**
     * Get the option parser.
     * @param \UIM\Console\ConsoleOptionParser  aParser The option parser to update
     */
  ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToUpdate) {
    parserToUpdate.description(
      "Clear all metadata caches for the connection. If a table name is provided, only that table will be removed."
    )
      .addOption("connection", [
          "help": "The connection to build/clear metadata cache data for.",
          "short": "c",
          "default": "default",
        ]).addArgument("name", [
          "help": "A specific table you want to clear cached data for.",
          "required": false,
        ]);

    return parserToUpdate;
  }
}
