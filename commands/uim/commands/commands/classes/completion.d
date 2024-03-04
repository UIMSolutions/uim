module uim.commands.completion;

import uim.commands;

@safe:

// Provide command completion shells such as bash.
class CompletionCommand : Command, ICommandCollectionAware {
   mixin(CommandThis!("Completion"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

    protected CommandCollection _commands;

    // Set the command collection used to get completion data on.
    void setCommandCollection(CommandCollection aCommandCollection) {
        this.commands = commandCollection;
    }

    // Gets the option parser instance and configures it.
    ConsoleOptionParser buildOptionParser(ConsoleOptionParser aConsoleParser) {
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
        aParser.addArgument("mode", [
                "help": "The type of thing to get completion on.",
                "required": true,
                "choices": modes.keys,
            ]);
        aParser.addArgument("command", [
                "help": "The command name to get information on.",
                "required": false,
            ]);
        aParser.addArgument("subcommand", [
                "help": "The sub-command related to command to get information on.",
                "required": false,
            ]);
        aParser.setEpilog(
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
    int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
        return match(commandArguments.getArgument("mode")) {
            "commands" : this.getCommands(commandArguments, aConsoleIo),
            "subcommands" : this.getSubcommands(commandArguments, aConsoleIo),
            "options" : this.getOptions(commandArguments, aConsoleIo),
            default : CODE_ERROR,
        };
    }

    // Get the list of defined commands.
    protected int getCommands(Arguments commandArguments, ConsoleIo aConsoleIo) {
        auto options = [];
        foreach (aKey, aValue; this.commands) {
            string[] someParts = split(" ", aKey);
            options ~= someParts[0];
        }
        options = array_unique(options);
        aConsoleIo.
        out (join(" ", options));

        return CODE_SUCCESS;
    }

    // Get the list of defined sub-commands.
    protected int getSubcommands(Arguments commandArguments, ConsoleIo aConsoleIo) {
        string commandName = commandArguments.getArgument("command");
        if (commandName.isNull || commandName.isEmpty) {
            return CODE_SUCCESS;
        }
        auto options = [];
        this.commands.byKeyValue
            .each!((kv) {
            string[] someParts = kv.key.split(" ");
                if (someParts[0] != commandName) {
                    continue;
                }
                // Space separate command name, collect
                // hits as subcommands
                if (count(someParts) > 1) {
                    options ~= join(" ", array_slice(someParts, 1));
                }
            });
        options = array_unique(options);
        aConsoleIo.
        out (join(" ", options));

        return CODE_SUCCESS;
    }

    // Get the options for a command or subcommand
    protected int getOptions(Arguments commandArguments, ConsoleIo aConsoleIo) {
        auto commandName = commandArguments.getArgument("command");
        auto subcommand = commandArguments.getArgument("subcommand");

        auto options = [];
        foreach (this.commands as aKey : aValue) {
            string[] someParts = split(" ", aKey);
            if (someParts[0] != commandName) {
                continue;
            }
            if (subcommand && !isSet(someParts[1])) {
                continue;
            }
            if (subcommand && isSet(someParts[1]) && someParts[1] != subcommand) {
                continue;
            }
            // Handle class strings
            if (isString(aValue)) {
                reflection = new ReflectionClass(aValue);
                aValue = reflection.newInstance();
                assert(cast(BaseCommand) aValue);
            }
            if (method_exists(aValue, "getOptionParser")) {
                aParser = aValue.getOptionParser();

                foreach (commandName, option; aParser.options()) {
                    options ~= "--commandName";
                    short = option.short();
                    if (short) {
                        options ~= "-short";
                    }
                }
            }
        }
        options = array_unique(options);
        aConsoleIo.out (join(" ", options));

        return static.CODE_SUCCESS;
    }
}
