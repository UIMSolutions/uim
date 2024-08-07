module uim.commands.classes.commands.version_;

import uim.commands;

@safe:

// Print out the version of UIM in use.
class DVersionCommand : DCommand {
  mixin(CommandThis!("Version"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  override override ulong execute(Json[string] arguments, IConsole aConsole = null) {
    //TODO aConsoleIo.writeln(Configure.currentVersion());

    return 0; //TODO CODE_SUCCESS;
  }
}
mixin(CommandCalls!("Version"));
