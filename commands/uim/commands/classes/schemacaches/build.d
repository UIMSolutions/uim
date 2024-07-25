module uim.commands.classes.commands.schemacaches.build;

import uim.commands;

@safe:

// Provides CLI tool for updating schema cache.
class DSchemacacheBuildCommand : DCommand {
   mixin(CommandThis!("SchemacacheBuild"));

  	override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

    // Get the command name.
    static string defaultName() {
        return "schema_cache-build";
    }
    
      override override ulong execute(Json[string] arguments, IConsole aConsole = null) {
    return super.execute(arguments, aConsoleIo);
  }

    /* 
    // Display all routes in an application
    override ulong execute(Json[string] arguments, IConsole aConsole = null) {
        SchemaCache schemaCache;
        try {
            aConnection = ConnectionManager.get(to!string(commandArguments.getOption("connection")));
            assert(cast(DConnection)aConnection);

            schemaCache = new DSchemaCache(aConnection);
        } catch (RuntimeException  anException) {
             aConsoleIo.error(anException.message());

            return CODE_ERROR;
        }

        auto aTables = cache.build(commandArguments.getArgument("name"));
        aTables.each!(table => aConsoleIo.verbose("Cached `%s`".format(table)));

        aConsoleIo.writeln("<success>Cache build complete</success>");

        return CODE_SUCCESS;
    }
    
    // Get the option parser.
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        parserToUpdate.description(
            "Build all metadata caches for the connection. If a " ~
            "table name is provided, only that table will be cached."
       ).addOption("connection", [
            "help": "The connection to build/clear metadata cache data for.",
            "short": "c",
            "default": "default",
        ]).addArgument("name", [
            "help": "A specific table you want to refresh cached data for.",
            "required": false.toJson,
        ]);

        return parserToUpdate;
    } */
}
