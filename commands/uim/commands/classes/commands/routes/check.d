module uim.commands.classes.commands.routes.check;

import uim.commands;

@safe:

// Provides interactive CLI tool for testing routes.
class DRoutesCheckCommand : DCommand {
  mixin(CommandThis!("RoutesCheck"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  static string defaultName() {
    return "routes-check";
  }

  override int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
    return super.execute(arguments, aConsoleIo);
  }

  /* 
  // Display all routes in an application
  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
    auto myUrl = commandArguments.getArgument("url");
    try {
      auto request = new DServerRequest(["url": url]);
      auto route = Router.parseRequest(request);
      string name = null;
      foreach (myRoute; Router.routes()) {
        if (myRoute.match(route)) {
          name = myRoute.options["_name"] ?  ? myRoute.name;
          break;
        }
      }
      unset(route["_route"], route["_matchedRoute"]);
      ksort(route);

      output = [
        ["Route name", "URI template", "Defaults"],
        [name, url, Json_encode(route, Json_THROW_ON_ERROR)],
      ];
      aConsoleIo.helper("table").output(output);
      aConsoleIo.out ();
    } catch (RedirectException anException) {
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
          "required": BooleanData(true),
        ]);

    return parserToUpdate;
  } */
}
