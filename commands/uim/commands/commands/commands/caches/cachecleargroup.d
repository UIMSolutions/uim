module uim.commands.caches.cachecleargroup;

import uim.commands;

@safe:

// Cache Clear Group command.
class CacheClearGroupCommand : Command {
  mixin!(CommandThis!("CacheClearGroupCommand"));

  	override bool initialize(IConfigData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
		return true;
	}

  // Get the command name.
  static string defaultName() {
    return "cache clear_group";
  }

  /**
     * Hook method for defining this command`s option parser.
     *
     * @see https://book.UIM.org/5/en/console-commands/option-parsers.html
     * @param \UIM\Console\ConsoleOptionParser  aParser The parser to be defined
     */
  ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToDefine) {
    auto definedParser = super.buildOptionParser(parserToDefine);
    definedParser.description("Clear all data in a single cache group.");
    definedParser.addArgument("group", [
        "help": "The cache group to clear. For example, `cake cache clear_group mygroup` will clear "
        ."all cache items belonging to group " mygroup".",
        "required": true,
      ]);
    definedParser.addArgument("config", [
        "help": "Name of the configuration to use. Defaults to no value which clears all cache configurations.",
      ]);

    return definedParser;
  }

  // Clears the cache group
  int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
    auto anGroup = to!string( commandArguments.getArgument("group"));
    try {
       anGroupConfigs = Cache.groupConfigs(anGroup);
    } catch (InvalidArgumentException anException) {
      aConsoleIo.error("Cache group " % s" not found".format(anGroup));

      return CODE_ERROR;
    }
    configData = commandArguments.getArgument("config");
    if (!configData.isNull && Cache.getConfig(configData).isNull) {
      aConsoleIo.error("Cache config " % s" not found".format(configData));

      return CODE_ERROR;
    }
    foreach (anGroupConfig,  anGroupConfigs[anGroup]) {
      if (!configData.isNull && configData !=  anGroupConfig) {
        continue;
      }
      if (!Cache.clearGroup(anGroup,  anGroupConfig)) {
        aConsoleIo.error(
            "Error encountered clearing group " % s". Was unable to clear entries for " % s"."
            .format(anGroup, anGroupConfig
        ));
        this.abort();
      } else {
        aConsoleIo.success("Group " % s" was cleared.".format(anGroup));
      }
    }
    return CODE_SUCCESS;
  }
}
