module uim.oop.commands.command;

import uim.oop;
@safe:

// Base class for commands
class DCommand : UIMObject, ICommand {
/*     mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // Implement this method with your command`s logic.
    abstract int execute(Json[string] options, IConsole console = null);
}
