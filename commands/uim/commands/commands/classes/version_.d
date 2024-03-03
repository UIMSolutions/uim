module uim.commands.version_;

import uim.commands;

@safe:

// Print out the version of UIM in use.
class VersionCommand : Command {
   mixin(CommandThis!("Version"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

  int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
        aConsoleIo.writeln(Configure.currentVersion());

        return CODE_SUCCESS;
    }
}
