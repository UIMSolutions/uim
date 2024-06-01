module uim.commands.classes.commands.command;

import uim.commands;

@safe:

// Base class for commands
class DCommand : ICommand {
    mixin TConfigurable;
    mixin TLocatorAware;
    mixin TLog;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Implement this method with your command`s logic.
    abstract int execute(Json[string] arguments, IConsoleIo aConsoleIo);
}
