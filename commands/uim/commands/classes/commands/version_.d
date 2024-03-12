module uim.commands.classes.commands.version_;

import uim.commands;

@safe:

// Print out the version of UIM in use.
class DVersionCommand : DCommand {
  mixin(CommandThis!("Version"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
    aConsoleIo.writeln(Configure.currentVersion());

    return CODE_SUCCESS;
  }
}

mixin(CommandCalls!("Version"));
