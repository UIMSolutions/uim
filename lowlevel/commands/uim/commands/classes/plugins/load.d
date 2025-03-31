/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.plugins.load;

import uim.commands;

@safe:

// Command for loading plugins.
class DPluginLoadCommand : DCommand {
  mixin(CommandThis!("PluginLoad"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // TODO configDataFile = CONFIG ~ "plugins.d";

    return true;
  }

  static string defaultName() {
    return "plugin-load";
  }

  //  Config file
  protected string _configDataFile;

  /*     override bool execute(Json[string] arguments, IConsole console = null) {
        return super.execute(arguments, consoleIo);
    }
 */
  override bool execute(Json[string] arguments, IConsole console = null) {
    /* auto plugin = arguments.getString("plugin");
        auto options = null;
        if (arguments.hasKey("only-debug")) {
            options.set("onlyDebug", true);
        }
        if (arguments.hasKey("only-cli")) {
            options.set("onlyCli", true);
        }
        if (arguments.hasKey("optional")) {
            options.set("optional", true);
        }
        IPlugin.VALID_HOOKS
            .filter!(hook => arguments.hasKey("no-" ~ hook))
            .each!(hook => options.set(hook, false));

        try {
            Plugin.getCollection().findPath(plugin);
        } catch (MissingPluginException anException) {
            if (options.isEmpty("optional")) {
                consoleIo.writeErrorMessages(anException.message());
                consoleIo.writeErrorMessages("Ensure you have the correct spelling and casing.");

                return false;
            }
        } */
    /* result = this.modifyConfigFile(plugin, options);
        if (result == false) {
            consoleIo.writeErrorMessages("Failed to update `CONFIG/plugins.d`");
        }
        consoleIo.success("Plugin added successfully to `CONFIG/plugins.d`");

        return result; */
    return false;
  }

  // Modify the plugins config file.
  protected int modifyConfigFile(string pluginName, Json[string] options = new Json[string]) {

    /*
        configData = @include _configFile;
        configData = !configData.isArray ? Json.empty;
    }
 */
    /* configuration.setEntry(pluginName, options);
    auto Json[string] = class_hasKey(VarExporter.classname)
        ? VarExporter.export_(configData, VarExporter.TRAILING_COMMA_IN_ARRAY) 
        : var_export_(configData, true);

    contents = "\n\n" ~ "return " ~ Json[string] ~ ";" ~ "\n";

    return file_put_contents(_configFile, contents)
        ? true : false; */
    return 0;
  }

  DConsoleOptionParser buildOptionParser(DConsoleOptionParser parser) {
    with (parser) {
      description("Command for loading plugins.");
/*       addArgument("plugin", MapHelper.create!(string, Json)
          .set("help", "Name of the plugin to load. Must be in CamelCase format. Example: uim plugin load Example")
          .set("required", true)
      );
      addOption("only-debug", MapHelper.create!(string, Json)
          .set("boolean", true)
          .set("help", "Load the plugin only when `debug` is enabled.")
      );
      addOption("only-cli", MapHelper.create!(string, Json)
          .set("boolean", true)
          .set("help", "Load the plugin only for CLI.")
      );
      Json[string] optional;
      optional.set("boolean", true);
      optional.set("help", "Do not throw an error if the plugin is not available.");
      addOption("optional", optional);

      Json[string] noBootstrap;
      addOption("no-bootstrap", MapHelper.create!(string, Json)
          .set("boolean", true)
          .set("help", "Do not run the `bootstrap()` hook.")
      );
      
      Json[string] noConsole;
      addOption("no-console", MapHelper.create!(string, Json)
          .set("boolean", true)
          .set("help", "Do not run the `console()` hook.")
      );
      
      Json[string] noMiddleware;
      noMiddleware.set("boolean", true);
      noMiddleware.set("help", "Do not run the `middleware()` hook..");
      addOption("no-middleware", noMiddleware);

      Json[string] noRoutes;
      addOption("no-routes", MapHelper.create!(string, Json)
          .set("boolean", true)
          .set("help", "Do not run the `routes()` hook.")
      );
      addOption("no-services", MapHelper.create!(string, Json)
          .set("boolean", true)
          .set("help", "Do not run the `services()` hook.")
      );
 */
    }
    return parser;
  }
}

mixin(CommandCalls!("PluginLoad"));
