module uim.commands.cacheclearall;

import uim.commands;

@safe:

// CacheClearall command.
class CacheClearallCommand : DCommand {
  mixin!(CommandThis!("CacheClearallCommand"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

  // Get the command name.
  static string defaultName() {
    return "cache clear_all";
  }

  /**
     * Hook method for defining this command`s option parser.
     *
     * @see https://book.UIM.org/5/en/console-commands/option-parsers.html
     * @param \UIM\Console\ConsoleOptionParser  aParser The parser to be defined
     */
  ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToBeDefined) {
    auto result = super.buildOptionParser(parserToBeDefined);
    result.description("Clear all data in all configured cache engines.");

    return result;
  }

  // Implement this method with your command`s logic.
  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
    auto myEngines = Cache . configured();
    myEngines.each!(engine => this.executeCommand(CacheClearCommand . class, [engine], aConsoleIo));

    return CODE_SUCCESS;
  }
}
