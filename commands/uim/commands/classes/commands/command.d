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

    this(IData[string] initData) {
        initialize(initData);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Implement this method with your command`s logic.
    int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        return 0;
    }
}
