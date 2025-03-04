/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.consoles.collection;

import uim.commands;
@safe:

version (test_uim_commands) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// Collection for Commands.
class DCommandCollection : UIMObject { // : IteratorAggregate, Countable {
    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(string name, Json[string] initData = null) {
        super(name, initData);
    }

    this(DCommand[string] newCommands) {
        this().addCommands(newCommands);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // Command list
    protected DCommand[string] _commands;

    // #region add
    // Add multiple commands at once.
    void addCommands(DCommand[string] newCommands) {
        newCommands.byKeyValue
            .each!(kv => addCommand(kv.key, kv.value));
    }

    // Add a command to the collection
    void addCommand(string commandName, DCommand newCommand) {
        _commands[commandName] = newCommand;
    }
    // #endregion add

    // Remove a command from the collection if it exists.
    bool removeKey(string[] commandNames) {
        return commandNames.all!(name => removeKey(name));
    }

    bool removeKey(string commandName) {
        return _commands.remove(commandName);
    }

    // Check whether the command name exists in the collection.
    bool has(string commandName) {
        return _commands.hasKey(commandName);
    }

    /* 
    // Get the target for a command.
    DCommand get(string commandName) {
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
        return _commands.length;
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
    /*  STRINGAA discoverPlugin(string pluginName) {
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
    protected DCommand[string] resolveNames(string[string][] anInput) {
        DCommand[string] results;
        foreach (anInfo; anInput) {
            auto infoName = anInfo["name"];
            addLong = infoName != anInfo["fullName"];

            // If the short name has been used, use the full name.
            // This allows app shells to have name preference.
            // and app shells to overwrite core shells.
            if (has(infoName) && addLong) {
                infoName = anInfo["fullName"];
            }

             classname = anInfo["class"];
             result[infoName] = classname;
            if (addLong) {
                 result[anInfo["fullName"]] = classname;
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
    string[] names() {
        return _commands.keys;
    }
}
