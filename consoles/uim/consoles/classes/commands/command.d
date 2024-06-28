module uim.consoles.classes.commands.command;

import uim.consoles;

@safe:

/**
 * Base class for console commands.
 *
 * Provides hooks for common command features:
 *
 * - `initialize` Acts as a post-construct hook.
 * - `buildOptionParser` Build/Configure the option parser for your command.
 * - `execute` Execute your command with parsed Json[string] and ConsoleIo
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\Command\Command>
 */
abstract class DConsoleCommand : DCommand, IConsoleCommand /* , IEventDispatcher */ {
    mixin(CommandThis!("Console"));
    //  @use \UIM\Event\EventDispatcherTrait<\UIM\Command\Command>
    mixin TEventDispatcher;
    mixin TValidatorAware;

    // Hook method
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

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
        return Inflector.underscore(name); */
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

    int run(Json[string] argv, DConsoleIo aConsoleIo) {
        this.initialize();

        aParser = getOptionParser();
        try {
            [options, arguments] = aParser.parse(argv, aConsoleIo);
            someArguments = new Json[string](
                arguments,
                options,
                aParser.argumentNames()
            );
        } catch (ConsoleException anException) {
            aConsoleIo.writeErrorMessages("Error: " ~ anException.getMessage());

            return CODE_ERROR;
        }
        setOutputLevel(someArguments, aConsoleIo);

        if (someArguments.getOption("help")) {
            this.displayHelp(aParser, someArguments, aConsoleIo);

            return CODE_SUCCESS;
        }
        if (someArguments.getOption("quiet")) {
            aConsoleIo.setInteractive(false);
        }
        dispatchEvent("Command.beforeExecute", ["args": someArguments]);
        /** @var int result  */
        result = this.execute(someArguments, aConsoleIo);
        dispatchEvent("Command.afterExecute", [
                "args": someArguments,
                "result": result
            ]);

        return result;
    }

    // Output help content
    protected void displayHelp(DConsoleOptionParser optionParser, Json[string] someArguments, DConsoleIo aConsoleIo) {
        string format = "text";
        if (someArguments.getArgumentAt(0) == "xml") {
            format = "xml";
            aConsoleIo.setOutputAs(ConsoleOutput.RAW);
        }
        aConsoleIo.writeln(optionParser.help(format));
    }

    // Set the output level based on the Json[string].
    protected void setOutputLevel(Json[string] someArguments, DConsoleIo aConsoleIo) {
        aConsoleIo.setLoggers(DConsoleIo.NORMAL);
        if (someArguments.hasKey("quiet")) {
            aConsoleIo.level(DConsoleIo.QUIET);
            aConsoleIo.setLoggers(DConsoleIo.QUIET);
        }
        if (someArguments.hasKey("verbose")) {
            aConsoleIo.level(DConsoleIo.VERBOSE);
            aConsoleIo.setLoggers(DataGetConsoleIo.VERBOSE);
        }
    }

    /**
     * Implement this method with your command`s logic.
     * Params:
     * \UIM\Console\Json[string] commandArguments The command arguments.
     */
    abstract ulong execute(Json[string] commandArguments, DConsoleIo aConsoleIo);

    // Halt the current process with a StopException.
    /* never abort(int exitCode = CODE_ERROR) {
        throw new DStopException("Command aborted", exitCode);
    } */

    /**
     * Execute another command with the provided set of arguments.
     *
     * If you are using a string command name, that command`s dependencies
     * will not be resolved with the application container. Instead you will
     * need to pass the command as an object with all of its dependencies.
     */
    ulong executeCommand(string commandClassname, Json[string] commandArguments = null, DConsoleIo aConsoleIo = null) {
        /* assert(
            isSubclass_of(command, ICommand.classname),
            "Command `%s` is not a subclass of `%s`.".format(command, ICommand.classname)
        ); */

        auto newCommand = new command();
        // return executeCommand(ICommand acommand, Json[string] commandArguments = null,  ? DConsoleIo aConsoleIo = null);
        return 0; 
    }

    ulong executeCommand(DCommand acommand, Json[string] commandArguments = null,  DConsoleIo aConsoleIo = null) {
        // auto myConsoleIo = aConsoleIo ?  : new DConsoleIo();

        /* try {
                return acommand.run(commandArguments, myConsoleIo);
            }
            catch (StopException anException) {
                return anException.code();
            } */
        return 0;
    }
}
