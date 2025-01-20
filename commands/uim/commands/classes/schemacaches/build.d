/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.schemacaches.build;

import uim.commands;

@safe:

// Provides CLI tool for updating schema cache.
class DSchemacacheBuildCommand : DCommand {
    mixin(CommandThis!("SchemacacheBuild"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // Get the command name.
    static string defaultName() {
        return "schema_cache-build";
    }

    /* override bool execute(Json[string] arguments, IConsole console = null) {
        return super.execute(arguments, aConsole);
    } */

    /* 
    // Display all routes in an application
    override bool execute(Json[string] arguments, IConsole console = null) {
        SchemaCache schemaCache;
        try {
            aConnection = ConnectionManager.get(to!string(commandArguments.getOption("connection")));
            assert(cast(DConnection)aConnection);

            schemaCache = new DSchemaCache(aConnection);
        } catch (RuntimeException  anException) {
             aConsole.error(anException.message());

            return false;
        }

        auto aTables = cache.build(commandArguments.getArgument("name"));
        aTables.each!(table => aConsole.verbose("Cached `%s`".format(table)));

        aConsole.writeln("<success>Cache build complete</success>");

        return true;
    }
    
    // Get the option parser.
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        parserToUpdate.description(
            "Build all metadata caches for the connection. If a " ~
            "table name is provided, only that table will be cached."
       ).addOption("connection", MapHelper.create!(string, Json)
            .set("help", "The connection to build/clear metadata cache data for.")
            .set("short", "c")
            .set("default", "default")
        ]).addArgument("name", MapHelper.create!(string, Json)
            .set("help", "A specific table you want to refresh cached data for.")
            .set("required", false)
        ]);

        return parserToUpdate;
    } */
}
