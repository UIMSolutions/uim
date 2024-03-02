module uim.commands.version_;

import uim.commands;

@safe:

// Print out the version of UIM in use.
class VersionCommand : Command {
   mixin(CommandThis!("VersionCommand"));

  	override bool initialize(IConfigData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
		return true;
	}

  int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
        aConsoleIo.writeln(Configure.currentVersion());

        return CODE_SUCCESS;
    }
}
