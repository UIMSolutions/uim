/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.routes.routes;

import uim.commands;

@safe:

// Provides interactive CLI tools for routing.
class DRoutesCommand : DCommand {
    mixin(CommandThis!("Routes"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    /* override bool execute(Json[string] arguments, IConsole console = null) {
        return super.execute(arguments, aConsole);
    } */

    /* 
    // Display all routes in an application
  override bool execute(Json[string] arguments, IConsole console = null) {
        auto myheader = ["Route name", "URI template", "Plugin", "Prefix", "Controller", "Action", "Method(s)"];
        if (arguments.hasKey("verbose")) {
             aHeader ~= "Defaults";
        }
        auto myavailableRoutes = Router.routes();
        output = someDuplicateRoutesCounter = null;

        someAvailableRoutes.each!((route) {
             someMethods = route.defaults.hasKey("_method") ? /* (array) * /
    route.defaults["_method"] : [""];

    anItem = [
        route.options.get("_name", route.name),
        route.templateText,
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
        if (!someDuplicateRoutesCounter.hasKey([route.templateText, method])) {
            someDuplicateRoutesCounter.setPath([route.templateText, method], 0);}
            someDuplicateRoutesCounter.inc([route.templateText, method], 1);};});

            if (arguments.getOption("sort")) {
                usort(output, auto(a, b) {
                    return strcasecmp(a[0], b[0]);});
                }
                output.unshift(aHeader);

                aConsole.helper("table").output(output);
                aConsole.writeln();

                someDuplicateRoutes = null;

                foreach (myRoute; someAvailableRoutes) {
                    string[] someMethods = myRoute.defaults.hasKey("_method") ?  /* (array) * / myRoute
                        .defaults["_method"] : [""];

                    someMethods.each!((method) {
                        string routeTemplateName = myRoute.templateName; if (
                            someDuplicateRoutesCounter[routeTemplateName][method] > 1 ||
                        (method.isEmpty && count(someDuplicateRoutesCounter[routeTemplateName]) > 1) ||
                        (method != "" && 
                        someDuplicateRoutesCounter.hasKey([routeTemplateName, ""])
                            ) {
                            someDuplicateRoutes ~= [
                                myRoute.options.getString("_name", myRoute.name),
                                routeTemplateName,
                                myRoute.defaults.getString("pluginName"),
                                myRoute.defaults.getString("prefix") /* Name * / ,
                                myRoute.defaults.getString("controNameller"),
                                myRoute.defaults.getString("action"),
                                someMethods.join(", "),
                            ]; break;}
                        });
                    }
                    if (someDuplicateRoutes) {
                        someDuplicateRoutes.unshift(aHeader);
                        aConsole.warning(
                            "The following possible route collisions were detected.");
                        aConsole.helper("table").output(someDuplicateRoutes);
                        aConsole.writeln();
                    }
                    return CODE_SUCCESS;
                }

                DConsoleOptionParser buildOptionParser(DConsoleOptionParser aParser) {
                    aParser
                        .description("Get the list of routes connected in this application.")
                        .addOption("sort", createMap!(string, Json)
                                .set("help", "sorts alphabetically by route name A-Z")
                                .set("short", "s")
                                .set("boolean", true));

                    return aParser;
                }
            }

            // Display all routes in an application
            override bool execute(Json[string] arguments, IConsole console = null) {
                if (commandArguments.getOption("verbose")) {
                    ksort(route.defaults);
                    anItem ~= Json_encode(route.defaults, Json_THROW_ON_ERROR);
                }
                output ~= anItem;

                someMethods.each!((method) {
                    if (someDuplicateRoutesCounter.isNull([route.templateText, method])) {
                        someDuplicateRoutesCounter[route.templateText][method] = 0;
                    }
                    someDuplicateRoutesCounter[route.templateText][method]++;
                });
            };

            if (commandArguments.getOption("sort")) {
                usort(output, auto(a, b) {
                    return strcasecmp(a[0], b[0]);});
                }
                output.unshift(aHeader);

                aConsole.helper("table").output(output);
                aConsole.writeln();

                auto someDuplicateRoutes = null;
                foreach (myRoute; someAvailableRoutes) {
                    string[] someMethods = myRoute.defaults.hasKey("_method") 
                        ?  /* (array) * /myRoute.defaults["_method"] 
                        : [""];

                    someMethods.each((method) {
                        if (
                            someDuplicateRoutesCounter.getInteger([myRoute.templateText, method]) > 1 ||
                        (method.isEmpty && count(someDuplicateRoutesCounter[myRoute.templateText]) > 1) ||
                        (method != "" && someDuplicateRoutesCounter.hasKey([myRoute.templateText, ""]))
                            ) {
                            someDuplicateRoutes ~= [
                                myRoute.options.getString("_name", myRoute.name),
                                myRoute.templateText,
                                myRoute.defaults.getString("plugin", ""),
                                myRoute.defaults.getString("prefix", ""),
                                myRoute.defaults.getString("controller", ""),
                                myRoute.defaults.getString("action", ""),
                                someMethods.join(", ")
                            ]; break;}
                        });
                    }
                    if (someDuplicateRoutes) {
                        someDuplicateRoutes.unshift(aHeader);
                        aConsole.warning(
                            "The following possible route collisions were detected.");
                        aConsole.helper("table").output(someDuplicateRoutes);
                        aConsole.writeln();
                    }
                    return CODE_SUCCESS;
                }

                DConsoleOptionParser buildOptionParser(
                    DConsoleOptionParser buildOptionParser aParser) {
                    aParser
                        .description("Get the list of routes connected in this application.")
                        .addOption("sort", createMap!(string, Json)
                            .set("help", "sorts alphabetically by route name A-Z")
                            .set("short", "s")
                            .set("boolean", true)
                        );

                    return aParser;
                }
            }
            */
}