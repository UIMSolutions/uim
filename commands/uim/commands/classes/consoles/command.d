/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.consoles.command;

import uim.commands;

@safe:

/**
 * Base class for console commands.
 *
 * Provides hooks for common command features:
 *
 * - `initialize` Acts as a post-construct hook.
 * - `buildOptionParser` Build/Configure the option parser for your command.
 * - `execute` Execute your command with parsed Json[string] and Console
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\Command\Command>
 */
class DConsoleCommand : DCommand, IConsoleCommand /* , IEventDispatcher */ {
    mixin(CommandThis!("Console"));
    //  @use \UIM\Event\EventDispatcherTrait<\UIM\Command\Command>
    /* mixin TEventDispatcher;
    mixin TValidatorAware; */

    // Get the command description.
    static string description() {
        return null;
    }

    // Get the root command name.
    string rootName() {
        string root = _name.split(" ").join(); // TODO

        return root;
    }

    // Hook method for defining this command`s option parser.
    protected IConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToDefine) {
        return null;
        // TODO return parserToDefine;
    }

    /**
     * Get the command name.
     *
     * Returns the command name based on class name.
     * For e.g. for a command with class name `UpdateTableCommand` the default
     * name returned would be `'update_table'`.
     */
    static string defaultName() {
        /* size_t pos = class.indexOf("\\");
        /** @psalm-suppress PossiblyFalseOperand * /
        string name = class.subString(pos + 1,  - 7);
        return name.underscore; */
        return null;
    }

    /**
     * Get the option parser.
     *
     * You can override buildOptionParser() to define your options & arguments.
     */
    DConsoleOptionParser getOptionParser() {
        /* [root, name] = split(" ", _name, 2);
        auto aParser = new DConsoleOptionParser buildOptionParser(name);
        aParser.setRootName(root);
        aParser.description(getDescription());
        aParser = this.buildOptionParser(aParser);

        return aParser; */
        return null;
    }

    ulong run(Json[string] arguments, DConsole console) {
        initialize();

        /*         auto aParser = getOptionParser();
        try {
            auto parsedResults = aParser.parse(arguments, console);
            auto arguments = MapHelper.create!(string, Json);
                /* parsedResults[1],
                parsedResults[0],
                aParser.argumentNames()
            ); * /
        } catch (DConsoleException anException) {
            console.writeErrorMessages("Error: " ~ anException.message());

            return 0; //false;
        }
        setOutputLevel(arguments, console);

        if (arguments.getOption("help")) {
            displayHelp(aParser, arguments, console);

            return 0; // true;
        }
        if (arguments.getOption("quiet")) {
            console.isInteractive(false);
        }
        dispatchEvent("Command.beforeExecute", ["args": arguments]);

        auto result = execute(arguments, console);
        dispatchEvent("Command.afterExecute", MapHelper.create!(string, Json)
            .set("args", arguments)
            .set("result", result)); */

        return 0; // result;
    }

    // Output help content
    protected void displayHelp(DConsoleOptionParser optionParser, Json[string] arguments, DConsole console) {
        /* string format = "text";
        if (arguments.getArgumentAt(0) == "xml") {
            format = "xml";
            console.setOutputAs(DOutput.RAW);
        }
        console.writeln(optionParser.help(format)); */
    }

    // Set the output level based on the Json[string].
    protected void setOutputLevel(Json[string] arguments, DConsole console) {
        // console.setLoggers(DConsole.NORMAL);
        /*  if (arguments.hasKey("quiet")) {
            console.level(DConsole.QUIET);
            console.setLoggers(DConsole.QUIET);
        }
        if (arguments.hasKey("verbose")) {
            console.level(DConsole.VERBOSE);
            console.setLoggers(DataGetConsole.VERBOSE);
        } */
    }

    // Implement this method with your command`s logic.
    override bool execute(Json[string] commandArguments, IConsole console = null) {
        return true;
    }

    // Halt the current process with a StopException.
    /* never abort(int exitCode = false) {
        throw new DStopException("Command aborted", exitCode);
    } */

    /**
     * Execute another command with the provided set of arguments.
     *
     * If you are using a string command name, that command`s dependencies
     * will not be resolved with the application container. Instead you will
     * need to pass the command as an object with all of its dependencies.
     */
    size_t executeCommand(string commandclassname, Json[string] commandArguments = null, DConsole console = null) {
        /* assert(
            isSubclass_of(command, ICommand.classname),
            "Command `%s` is not a subclass of `%s`.".format(command, ICommand.classname)
        ); */

        // auto newCommand = new command();
        // return executeCommand(ICommand acommand, Json[string] commandArguments = null,  ? DConsole console = null);
        return 0;
    }

    size_t executeCommand(DCommand command, Json[string] commandArguments = null, DConsole console = null) {
        /* auto console = console ? console : new DConsole(); */

        /* try {
                return command.run(commandArguments, console);
            }
            catch (StopException anException) {
                return anException.code();
            } */
        return 0;
    }
}
