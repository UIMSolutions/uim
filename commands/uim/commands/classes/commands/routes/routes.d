module uim.commands.classes.commands.routes.routes;

import uim.commands;

@safe:

// Provides interactive CLI tools for routing.
class DRoutesCommand : DCommand {
   mixin(CommandThis!("Routes"));

  	override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

  override int execute(Json[string] arguments, IConsoleIo aConsoleIo) {
    return super.execute(arguments, aConsoleIo);
  }

    /* 
    // Display all routes in an application
  int execute(Json[string] arguments, IConsoleIo aConsoleIo) {
        auto myheader = ["Route name", "URI template", "Plugin", "Prefix", "Controller", "Action", "Method(s)"];
        if (arguments.hasKey("verbose")) {
             aHeader ~= "Defaults";
        }
        auto myavailableRoutes = Router.routes();
        output = someDuplicateRoutesCounter = null;

        someAvailableRoutes.each!((route) {
             someMethods = isSet(route.defaults["_method"]) ? (array)route.defaults["_method"] : [""];

             anItem = [
                route.options.get("_name", route.name),
                route.template,
                route.defaults.get("plugin", ""),
                route.defaults.get("prefix", ""),
                route.defaults.get("controller", ""),
                route.defaults.get("action", ""),
                someMethods.join(", "),
            ];

            if (arguments.getOption("verbose")) {
                ksort(route.defaults);
                 anItem ~= Json_encode(route.defaults, Json_THROW_ON_ERROR);
            }
            output ~= anItem;

            someMethods.each!((method) {
                if (!isSet(someDuplicateRoutesCounter[route.template][method])) {
                     someDuplicateRoutesCounter[route.template][method] = 0;
                }
                someDuplicateRoutesCounter[route.template][method]++;
            });
        });

        if (arguments.getOption("sort")) {
            usort(output, auto (a, b) {
                return strcasecmp(a[0], b[0]);
            });
        }
        array_unshift(output,  aHeader);

         aConsoleIo.helper("table").output(output);
         aConsoleIo.writeln();

         someDuplicateRoutes = null;

        foreach (myRoute;  someAvailableRoutes) {
            string[] someMethods = isSet(myRoute.defaults["_method"]) ? (array)myRoute.defaults["_method"] : [""];

            someMethods.each!((method) {
                if (
                     someDuplicateRoutesCounter[myRoute.template][method] > 1 ||
                    (method.isEmpty && count(someDuplicateRoutesCounter[myRoute.template]) > 1) ||
                    (method != "" && isSet(someDuplicateRoutesCounter[myRoute.template][""]))
                ) {
                     someDuplicateRoutes ~= [
                        myRoute.options["_name"] ?? myRoute.name,
                        myRoute.template,
                        myRoute.defaults.get("plugin", ""),
                        myRoute.defaults.get("prefix", ""),
                        myRoute.defaults.get("controller", ""),
                        myRoute.defaults.get("action", ""),
                        someMethods.join(", "),
                    ];

                    break;
                }
            });
        }
        if (someDuplicateRoutes) {
            array_unshift(someDuplicateRoutes,  aHeader);
            aConsoleIo.warning("The following possible route collisions were detected.");
            aConsoleIo.helper("table").output(someDuplicateRoutes);
            aConsoleIo.writeln();
        }
        return CODE_SUCCESS;
    }

    DConsoleOptionParser buildOptionParser(DConsoleOptionParser buildOptionParser  aParser) {
         aParser
            .description("Get the list of routes connected in this application.")
            .addOption("sort", [
                "help": "sorts alphabetically by route name A-Z",
                "short": "s",
                "boolean": true.toJson,
            ]);

        return aParser;
    } */
}

/*// Display all routes in an application
  int execute(Json[string] arguments, IConsoleIo aConsoleIo) {
            if (commandArguments.getOption("verbose")) {
                ksort(route.defaults);
                 anItem ~= Json_encode(route.defaults, Json_THROW_ON_ERROR);
            }
            output ~= anItem;

            someMethods.each!((method) {
                if (!isSet(someDuplicateRoutesCounter[route.template][method])) {
                     someDuplicateRoutesCounter[route.template][method] = 0;
                }
                someDuplicateRoutesCounter[route.template][method]++;
            });
        });

        if (commandArguments.getOption("sort")) {
            usort(output, auto (a, b) {
                return strcasecmp(a[0], b[0]);
            });
        }
        array_unshift(output,  aHeader);

         aConsoleIo.helper("table").output(output);
         aConsoleIo.writeln();

         someDuplicateRoutes = null;

        foreach (myRoute;  someAvailableRoutes) {
            string[] someMethods = isSet(myRoute.defaults["_method"]) ? (array)myRoute.defaults["_method"] : [""];

            someMethods.each((method) {
                if (
                     someDuplicateRoutesCounter[myRoute.template][method] > 1 ||
                    (method.isEmpty && count(someDuplicateRoutesCounter[myRoute.template]) > 1) ||
                    (method != "" && isSet(someDuplicateRoutesCounter[myRoute.template][""]))
                ) {
                     someDuplicateRoutes ~= [
                        myRoute.options["_name"] ?? myRoute.name,
                        myRoute.template,
                        myRoute.defaults.get("plugin", ""),
                        myRoute.defaults.get("prefix", ""),
                        myRoute.defaults.get("controller", ""),
                        myRoute.defaults.get("action", ""),
                        someMethods.join(", "),
                    ];

                    break;
                }
            }
        }
        if (someDuplicateRoutes) {
            array_unshift(someDuplicateRoutes,  aHeader);
            aConsoleIo.warning("The following possible route collisions were detected.");
            aConsoleIo.helper("table").output(someDuplicateRoutes);
            aConsoleIo.writeln();
        }
        return CODE_SUCCESS;
    }

    DConsoleOptionParser buildOptionParser(DConsoleOptionParser buildOptionParser  aParser) {
         aParser
            .description("Get the list of routes connected in this application.")
            .addOption("sort", [
                "help": "sorts alphabetically by route name A-Z",
                "short": "s",
                "boolean": true.toJson,
            ]);

        return aParser;
    }
}
 */

