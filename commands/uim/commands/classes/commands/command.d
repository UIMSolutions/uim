module uim.commands.classes.commands.command;

import uim.commands;

@safe:

// Base class for commands
class DCommand : ICommand {
    this() { initialize; }

    bool initialize(IData[string] initData = null) {
        return true;
    }

    mixin(TProperty!("string", "name"));
    
    //TODO mixin configForClass(); 

    //TODO mixin LocatorAwareTemplate();
    //TODO mixin LogTemplate();

    // Implement this method with your command`s logic.
    int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        return 0;
    }
}
