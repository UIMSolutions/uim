module commands.uim.commands.classes.commands.command;

import uim.commands;

@safe:

/**
 * Base class for commands using the full stack UIM Framework.
 *
 * Includes traits that integrate logging and ORM models to console commands.
 */
class Command : ICommand {
    this() { /* initialize;  */ }

    /* 
    mixin configForClass(); 

    mixin LocatorAwareTemplate();
    mixin LogTemplate();

    */ 
    // Implement this method with your command`s logic.
    /* int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
        return 0;
    } */
}
