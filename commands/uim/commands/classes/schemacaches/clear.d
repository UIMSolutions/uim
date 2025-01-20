/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.schemacaches.clear;

import uim.commands;

@safe:

// Provides CLI tool for clearing schema cache.
class DSchemacacheClearCommand : DCommand {
  mixin(CommandThis!("SchemacacheClear"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // Get the command name.
  static string defaultName() {
    return "schema_cache-clear";
  }

  /* override bool execute(Json[string] arguments, IConsole console = null) {
    return super.execute(arguments, aConsole);
  } */

  /* 

  // Display all routes in an application
  override bool execute(Json[string] arguments, IConsole console = null) {
    try {
      aConnection = ConnectionManager . get(to!string(commandArguments.getOption("connection")));
      assert(cast(Connection)aConnection);

      cache = new DSchemaCache(aConnection);
    } catch (RuntimeException anException) {
      aConsole.error(anException.message());

      return false;
    }
    
    auto tables = cache.clear(commandArguments.getArgument("name"));
    tables.each!(table => aConsole.verbose("Cleared `%s`".format(aTable)));
    aConsoleio.out ("<success>Cache clear complete</success>");

    return true;
  } */

  // Get the option parser.
  /* DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
    with (parserToUpdate) {
      description(
        "Clear all metadata caches for the connection. If a table name is provided, only that table will be removed."
      );

      addOption("connection", MapHelper.create!(string, Json)
          .set("help", "The connection to build/clear metadata cache data for.")
          .set("short", "c")
          .set("default", "default")
      );

      addArgument("name", MapHelper.create!(string, Json)
          .set("help", "A specific table you want to clear cached data for.")
          .set("required", false)
      );
    }
    return parserToUpdate;
  } */
}
