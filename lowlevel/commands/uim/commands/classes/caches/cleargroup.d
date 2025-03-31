/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.caches.cleargroup;

import uim.commands;
@safe:

version (test_uim_commands) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// Cache Clear Group command.
class DCacheClearGroupCommand : DCommand {
  mixin(CommandThis!("CacheClearGroup"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // Get the command name.
  static string defaultName() {
    return "cache clear_group";
  }

  // Hook method for defining this command`s option parser.
  /* DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToDefine) {
    auto definedParser = super.buildOptionParser(parserToDefine);
    with (definedParser) {
      description("Clear all data in a single cache group.");
      addArgument("group", MapHelper.create!(string, Json)
          .set("help", "The cache group to clear. For example, `uim cache clear_group mygroup` will clear "
            ~ "all cache items belonging to group 'mygroup'.")
          .set("required", true)
      );
      addArgument("config", MapHelper.create!(string, Json)
          .set("help", "Name of the configuration to use. Defaults to no value which clears all cache configurations.")
      );
    }

    return definedParser;
  } */

  // Clears the cache group
  override bool execute(Json[string] arguments, IConsole console = null) {
/*     auto anGroup = to!string(commandArguments.getArgument("group"));
    try {
      anGroupConfigs = Cache.groupConfigs(anGroup);
    } catch (InvalidArgumentException anException) {
      console.error("Cache group '%s' not found".format(anGroup));

      return false;
    }

    auto configData = commandArguments.getArgument("config");
    if (!configData.isNull && Cache.configuration.getEntry(configData).isNull) {
      console.error("Cache config '%s' not found".format(configData));

      return false;
    }
    anGroupConfigs[anGroup]
      .filter(config => configData.isNull || configData == config)
      .each!((config) {
        if (!Cache.clearGroup(anGroup, config)) {
          console.error(
            "Error encountered clearing group '%s'. Was unable to clear entries for '%s'."
            .format(anGroup, config));
          abort();
        } else {
          console.success("Group '%s' was cleared.".format(anGroup));
        }
      }); */

    return true;
  }
}
