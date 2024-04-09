module uim.commands.classes.commands.routes.generate;

import uim.commands;

@safe:

// Provides interactive CLI tools for URL generation
class DRoutesGenerateCommand : DCommand {
   mixin(CommandThis!("RoutesGenerate"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

  static string defaultName() {
    return "routes-generate";
  }

  /* 
  // Display all routes in an application
  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
    try {
      commandArguments = _splitArgs(commandArguments.getArguments());
      auto routerUrl = Router.url(commandArguments);
      aConsoleIo.out ("> " ~ routerUrl);
      aConsoleIo.out ();
    } catch (MissingRouteException) {
      aConsoleIo.writeErrorMessages(
        "<warning>The provided parameters do not match any routes.</warning>");
      aConsoleIo.out ();

      return CODE_ERROR;
    }
    return CODE_SUCCESS;
  }

  // Split the CLI arguments into a hash.
  protected array < string | bool > _splitArgs(string[] commandArguments) {
    auto result = [];
    foreach (myArgument; commandArguments) {
      if (myArgument.has(":")) {
        [aKey, aValue] = split(":", myArgument);
        if (in_array(aValue, ["true", "false"], true)) {
          aValue = aValue == "true";
        }

        result[aKey] = aValue;
      } else {
        result ~= myArgument;
      }
    }
    return result;
  }

  DConsoleOptionParser buildOptionParser buildOptionParser(DConsoleOptionParser buildOptionParser parserToUpdate) {
    parserToUpdate.description(
      "Check a routing array against the routes. "."Will output the URL if there is a match." ~ "\n\n" ~
        "Routing parameters should be supplied in a key:value format. " ~
        "For example `controller:Articles action:view 2`"
    );

    return parserToUpdate;
  } */
}
