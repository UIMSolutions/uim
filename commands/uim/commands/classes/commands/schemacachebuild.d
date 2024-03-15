module uim.commands;

import uim.commands;

@safe:

// Provides CLI tool for updating schema cache.
class DSchemacacheBuildCommand : DCommand {
   mixin(CommandThis!("SchemacacheBuild"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

    // Get the command name.
    static string defaultName() {
        return "schema_cache build";
    }
    
    /* 
    // Display all routes in an application
    int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        SchemaCache schemaCache;
        try {
            aConnection = ConnectionManager.get(to!string(commandArguments.getOption("connection")));
            assert(cast(Connection)aConnection);

            schemaCache = new SchemaCache(aConnection);
        } catch (RuntimeException  anException) {
             aConsoleIo.error(anException.getMessage());

            return CODE_ERROR;
        }

        auto aTables = cache.build(commandArguments.getArgument("name"));
        aTables.each!(table => aConsoleIo.verbose("Cached `%s`".format(table)));

        aConsoleIo.writeln("<success>Cache build complete</success>");

        return CODE_SUCCESS;
    }
    
    // Get the option parser.
    ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToUpdate) {
        parserToUpdate.description(
            "Build all metadata caches for the connection. If a " ~
            "table name is provided, only that table will be cached."
        ).addOption("connection", [
            "help": "The connection to build/clear metadata cache data for.",
            "short": "c",
            "default": "default",
        ]).addArgument("name", [
            "help": "A specific table you want to refresh cached data for.",
            "required": false,
        ]);

        return parserToUpdate;
    } */
}
