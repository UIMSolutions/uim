/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.caches.cleargroup;

import uim.commands;

@safe:

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
      addArgument("group", createMap!(string, Json)
          .set("help", "The cache group to clear. For example, `uim cache clear_group mygroup` will clear "
            ~ "all cache items belonging to group 'mygroup'.")
          .set("required", true)
      );
      addArgument("config", createMap!(string, Json)
          .set("help", "Name of the configuration to use. Defaults to no value which clears all cache configurations.")
      );
    }

    return definedParser;
  } */

  // Clears the cache group
  /* override */ ulong execute(Json[string] arguments, IConsole aConsole = null) {
    auto anGroup = to!string(commandArguments.getArgument("group"));
    try {
      anGroupConfigs = Cache.groupConfigs(anGroup);
    } catch (InvalidArgumentException anException) {
      aConsoleIo.error("Cache group '%s' not found".format(anGroup));

      return CODE_ERROR;
    }

    auto configData = commandArguments.getArgument("config");
    if (!configData.isNull && Cache.configuration.get(configData).isNull) {
      aConsoleIo.error("Cache config '%s' not found".format(configData));

      return CODE_ERROR;
    }
    anGroupConfigs[anGroup]
      .filter(config => configData.isNull || configData == config)
      .each!((config) {
        if (!Cache.clearGroup(anGroup, config)) {
          aConsoleIo.error(
            "Error encountered clearing group '%s'. Was unable to clear entries for '%s'."
            .format(anGroup, config));
          abort();
        } else {
          aConsoleIo.success("Group '%s' was cleared.".format(anGroup));
        }
      });

    return CODE_SUCCESS;
  }
}
