module uim.consoles.classes.commands.collection;

import uim.consoles;

@safe:

// Collection for Commands.
class DCommandCollection { // : IteratorAggregate, Countable {
    mixin TConfigurable;

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
    // Command list
    protected ICommand[string] _commands;

    this(ICommand[string] newCommands) {
        newCommands.byKeyValue
          .each!(nameCommand => add(nameCommand.key, nameCommand.value));
    }
    // Add a command to the collection
    void addCommand(string commandName, ICommand newCommand) {
        _commands[commandName] = newCommand;
    }
    // Add multiple commands at once.
    void addCommands(ICommand[string] newCommands) {
        newCommands.byKeyValue
            .each!(kv => addCommand(kv.key, kv.value));
    }

    // Remove a command from the collection if it exists.
    void remove(string commandName) {
        _commands.remove(commandName);
    }

    // Check whether the command name exists in the collection.
    bool has(string commandName) {
        return _commands.hasKey(commandName);
    }

    /* 
    // Get the target for a command.
    ICommand get(string commandName) {
        if (!has(commandName)) {
            throw new DInvalidArgumentException("The `%s` is not a known command name.".format(commandName));
        }
        return _commands[commandName];
    }

    // TODO
    /* 
    // Implementation of IteratorAggregate.
    Traversable getIterator() {
        return new DArrayIterator(_commands);
    }
    */ 

    // Get the number of commands in the collection.
    size_t count() {
        return _commands.lenth;
    }

    /**
     * Auto-discover commands from the named plugin.
     *
     * Discovered commands will have their names de-duplicated with
     * existing commands in the collection. If a command is already
     * defined in the collection and discovered in a plugin, only
     * the long name (`plugin.command`) will be returned.
     */
     // TODO
/*    STRINGAA discoverPlugin(string pluginName) {
        auto commandScanner = new DCommandScanner();
        auto pluginShells = commandScanner.scanPlugin(pluginName);

        return _resolveNames(pluginShells);
    } */
    
    /**
     * Resolve names based on existing commands
     * Params:
     * <>  anInput The results of a CommandScanner operation.
     */
    // TODO
    /* 
    protected ICommand[string] resolveNames(STRINGAA[] anInput) {
        ICommand[string] results;
        foreach (anInfo; anInput) {
            auto infoName = anInfo["name"];
            addLong = infoName != anInfo["fullName"];

            // If the short name has been used, use the full name.
            // This allows app shells to have name preference.
            // and app shells to overwrite core shells.
            if (this.has(infoName) && addLong) {
                infoName = anInfo["fullName"];
            }

             className = anInfo["class"];
             result[infoName] = className;
            if (addLong) {
                 result[anInfo["fullName"]] = className;
            }
        }

        return results;
    }
    */
    
    /**
     * Automatically discover commands in UIM, the application and all plugins.
     *
     * Commands will be located using filesystem conventions. Commands are
     * discovered in the following order:
     *
     * - UIM provided commands
     * - Application commands
     *
     * Commands defined in the application will overwrite commands with
     * the same name provided by UIM.
     */
     // TODO
    /*
    STRINGAA autoDiscover() {
        auto myScanner = new DCommandScanner();

        auto core = resolveNames(myScanner.scanCore());
        auto app = resolveNames(myScanner.scanApp());

        return app + core;
    }
    */
    
    // Get the list of available command names.
    string[] commandNames() {
        return _commands.keys;
    }
}
