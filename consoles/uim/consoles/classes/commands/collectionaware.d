module uim.consoles.classes.commands.collectionaware;

import uim.consoles;

@safe:

// An interface for shells that take a CommandCollection during initialization.
interface ICommandCollectionAware {
    // Set the command collection being used.
    void setCommandCollection(CommandCollection commands);
}
