/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.completion;

import uim.commands;

@safe:

// Provide command completion shells such as bash.
class DCompletionCommand : DCommand { // TODO}, ICommandCollectionAware {
    mixin(CommandThis!("Completion"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    /* protected ICommandCollection _commands;

    // Set the command collection used to get completion data on.
    void commandCollection(CommandCollection aCommandCollection) {
        _commands = commandCollection;
    } */

    /* 
    // Gets the option parser instance and configures it.
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser buildOptionParser aConsoleParser) {
        STRINGAA modes = [
            "commands": "Output a list of available commands",
            "subcommands": "Output a list of available sub-commands for a command",
            "options": "Output a list of available options for a command and possible subcommand.",
        ];

        string modeHelp = modes.byKeyValue
            .map!(kv => "- <info>%s</info> %s\n".format(kv.key, kv.value)).join;

        aParser.description(
            "Used by shells like bash to autocomplete command name, options and arguments"
       );
        aParser.addArgument("mode", Map.create!(string, Json)
            .set("help", "The type of thing to get completion on.")
            .set("required", true)
            .set("choices", modes.keys)
        );
        aParser.addArgument("command", Map.create!(string, Json)
            .set("help", "The command name to get information on.")
            .set("required", false)
        );
        aParser.addArgument("subcommand", Map.create!(string, Json)
            .set("help", "The sub-command related to command to get information on.")
            .set("required", false)
        );
        aParser.epilog(
            [
            "The various modes allow you to get help information on commands and their arguments.",
            "The available modes are:",
            "",
            myModeHelp,
            "",
            "This command is not intended to be called manually, and should be invoked from a " ~
            "terminal completion script.",
        ]);

        return aParser;
    }

    // Main auto Prints out the list of commands.
    override bool execute(Json[string] arguments, IConsole console = null) {
        return match(commandArguments.getArgument("mode")) {
            "commands" : getCommands(commandArguments, aConsole),
            "subcommands" : getSubcommands(commandArguments, aConsole),
            "options" : options(commandArguments, aConsole),
            default : false,
        };
    }

    // Get the list of defined commands.
    protected int getCommands(Json[string] arguments, IConsole aConsole) {
        auto options = null;
        foreach (aKey, aValue; _commands) {
            string[] someParts = aKey.split(" ");
            options ~= someParts[0];
        }
        options = options.unique;
        aConsole.
        out (join(" ", options));

        return true;
    }

    // Get the list of defined sub-commands.
    protected int getSubcommands(Json[string] arguments, IConsole aConsole) {
        string commandName = commandArguments.getArgument("command");
        if (commandName.isNull || commandName.isEmpty) {
            return true;
        }
        auto options = null;
        _commands.byKeyValue
            .each!((kv) {
                string[] someParts = kv.key.split(" ");
                if (someParts[0] != commandName) {
                    continue;
                }
                // Space separate command name, collect
                // hits as subcommands
                if (count(someParts) > 1) {
                    options ~= someParts.slice(1).join(" ");
                }
            });
        options = options.unique;
        aConsole.out (options.join(" "));

        return true;
    }

    // Get the options for a command or subcommand
    protected int options(Json[string] arguments, IConsole aConsole) {
        auto commandName = commandArguments.getArgument("command");
        auto subcommand = commandArguments.getArgument("subcommand");

        auto options = null;
        foreach (aKey, aValue, _commands) {
            string[] someParts = aKey.split(" ");
            if (someParts[0] != commandName) {
                continue;
            }
            if (subcommand && someParts.isNull(1)) {
                continue;
            }
            if (subcommand && someParts.has(1) && someParts[1] != subcommand) {
                continue;
            }
            // Handle class strings
            if (isString(aValue)) {
                reflection = new DReflectionClass(aValue);
                aValue = reflection.newInstance();
                assert(cast(BaseCommand) aValue);
            }
            if (hasMethod(aValue, "getOptionParser")) {
                aParser = aValue.getOptionParser();

                 aParser.options().byKeyValue
                    .each!(commandOption) {
                        options ~= "--commandOption.command";
                        if (auto short = commandOption.value.short()) {
                            options ~= "-short";
                        }
                });
            }
        }
        options = options.unique;
        aConsole.out (options.join(" "));

        return static.true;
    } */
}
