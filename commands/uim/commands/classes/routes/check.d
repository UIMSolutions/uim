module uim.commands.classes.commands.routes.check;

import uim.commands;

@safe:

// Provides interactive CLI tool for testing routes.
class DRoutesCheckCommand : DCommand {
  mixin(CommandThis!("RoutesCheck"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  static string defaultName() {
    return "routes-check";
  }

  override override ulong execute(Json[string] arguments, IConsole aConsole = null) {
    return super.execute(arguments, aConsoleIo);
  }

  /* 
  // Display all routes in an application
  override ulong execute(Json[string] arguments, IConsole aConsole = null) {
    auto myUrl = commandArguments.getArgument("url");
    try {
      auto request = new DServerRequest(["url": url]);
      auto route = Router.parseRequest(request);
      string name = null;
      foreach (route; Router.routes()) {
        if (route.match(route)) {
          name = route.options.getString("_name", route.name);
          break;
        }
      }
      
      route.remove("_route", "_matchedRoute");
      ksort(route);

      output = [
        ["Route name", "URI template", "Defaults"],
        [name, url, Json_encode(route, Json_THROW_ON_ERROR)],
      ];
      aConsoleIo.helper("table").output(output);
      aConsoleIo.out ();
    } catch (DRedirectException anException) {
      output = [
        ["URI template", "Redirect"],
        [url, anException.getMessage()],
      ];
      aConsoleIo.helper("table").output(output);
      aConsoleIo.out ();
    } catch (MissingRouteException) {
      aConsoleIo.warning("'url' did not match any routes.");
      aConsoleIo.out ();

      return CODE_ERROR;
    }
    return CODE_SUCCESS;
  }

  DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
    parserToUpdate.description(
      "Check a URL string against the routes. " ~
        "Will output the routing parameters the route resolves to."
   )
      .addArgument("url", [
          "help": "The URL to check.",
          "required": true.toJson,
        ]);

    return parserToUpdate;
  } */
}
