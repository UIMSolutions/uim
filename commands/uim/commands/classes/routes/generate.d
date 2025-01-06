/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.routes.generate;    

import uim.commands;

@safe:

// Provides interactive CLI tools for URL generation
class DRoutesGenerateCommand : DCommand {
   mixin(CommandThis!("RoutesGenerate"));

    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }
    
    return true;
  }

  static string defaultName() {
    return "routes-generate";
  }

  override bool execute(Json[string] arguments, IConsole console = null) {
    return super.execute(arguments, aConsole);
  }

  /* 
  // Display all routes in an application
  override bool execute(Json[string] arguments, IConsole console = null) {
    try {
      commandArguments = _splitArgs(commandArguments.getArguments());
      auto routerUrl = Router.url(commandArguments);
      aConsole.out ("> " ~ routerUrl);
      aConsole.out ();
    } catch (MissingRouteException) {
      aConsole.writeErrorMessages(
        "<warning>The provided parameters do not match any routes.</warning>");
      aConsole.out ();

      return false;
    }
    return true;
  }

  // Split the CLI arguments into a hash.
  protected Json[string] < string | bool > _splitArgs(string[] commandArguments) {
    auto result = null;
    commandArguments.each!((argument) {
      if (argument.contains(": ")) {
        [aKey, aValue] = argument.split(": ");
        if (isIn(aValue, ["true", "false"], true)) {
          aValue = aValue == "true";
        }

        result[aKey] = aValue;
      } else {
        result ~= argument;
      }
    });

    return result;
  }

  DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
    parserToUpdate.description(
      "Check a routing array against the routes. "."Will output the URL if there is a match." ~ "\n\n" ~
        "Routing parameters should be supplied in a key:value format. " ~
        "For example `controller:Articles action:view 2`"
   );

    return parserToUpdate;
  } */
}
