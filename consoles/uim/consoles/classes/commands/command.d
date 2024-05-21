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
abstract class DConsoleCommand : IConsoleCommand /* , IEventDispatcher */ {
    mixin TConfigurable;
    //  @use \UIM\Event\EventDispatcherTrait<\UIM\Command\Command>
    mixin TEventDispatcher;
    mixin TValidatorAware;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    // The name of this command.
    protected string _name = "unknown command";

    @property void name(string newName) {
        /* assert(
            newName.has(" ") && !newName.startsWith(" "),
            "The name '{name}' is missing a space. Names should look like `uim routes`"
        ); */ 
        _name = newName;
    }

    // Get the command name.
    @property string name() {
        return _name;
    }

    // Get the command description.
    static string description() {
        return "";
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
        size_t pos = indexOf(class, "\\");
        /** @psalm-suppress PossiblyFalseOperand */
        string name = substr(class, pos + 1,  - 7);
        return Inflector.underscore(name);
    }

    /**
     * Get the option parser.
     *
     * You can override buildOptionParser() to define your options & arguments.
     */
    DConsoleOptionParser buildOptionParser getOptionParser() {
        [root, name] = split(" ", _name, 2);
        aParser = new DConsoleOptionParser buildOptionParser(name);
        aParser.setRootName(root);
        aParser.description(getDescription());

        aParser = this.buildOptionParser(aParser);

        return aParser;
    }

    int run(Json[string] argv, IConsoleIo aConsoleIo) {
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
        this.dispatchEvent("Command.beforeExecute", ["args": someArguments]);
        /** @var int result  */
        result = this.execute(someArguments, aConsoleIo);
        this.dispatchEvent("Command.afterExecute", [
                "args": someArguments,
                "result": result
            ]);

        return result;
    }

    // Output help content
    protected void displayHelp(DConsoleOptionParser optionParser, Json[string] someArguments, IConsoleIo aConsoleIo) {
        string format = "text";
        if (someArguments.getArgumentAt(0) == "xml") {
            format = "xml";
            aConsoleIo.setOutputAs(ConsoleOutput.RAW);
        }
        aConsoleIo.writeln(optionParser.help(format));
    }

    // Set the output level based on the Json[string].
    protected void setOutputLevel(Json[string] someArguments, IConsoleIo aConsoleIo) {
        aConsoleIo.setLoggers(ConsoleIo.NORMAL);
        if (someArguments.hasKey("quiet")) {
            aConsoleIo.level(ConsoleIo.QUIET);
            aConsoleIo.setLoggers(ConsoleIo.QUIET);
        }
        if (someArguments.hasKey("verbose")) {
            aConsoleIo.level(ConsoleIo.VERBOSE);
            aConsoleIo.setLoggers(ConsoleIo.VERBOSE);
        }
    }

    /**
     * Implement this method with your command`s logic.
     * Params:
     * \UIM\Console\Json[string] someArguments The command arguments.
     */
    abstract int execute(Json[string] someArguments, IConsoleIo aConsoleIo);

    // Halt the current process with a StopException.
    never abort(int exitCode = self.CODE_ERROR) {
        throw new DStopException("Command aborted", exitCode);
    }

    /**
     * Execute another command with the provided set of arguments.
     *
     * If you are using a string command name, that command`s dependencies
     * will not be resolved with the application container. Instead you will
     * need to pass the command as an object with all of its dependencies.
     */
    int executeCommand(string commandClass name, Json[string] commandArguments = null, IConsoleIo aConsoleIo = null) {
        assert(
            isSubclass_of(command, ICommand.classname),
            "Command `%s` is not a subclass of `%s`.".format(command, ICommand.classname)
        );

        auto newCommand = new command();
        return executeCommand(ICommand acommand, Json[string] commandArguments = null,  ? IConsoleIo aConsoleIo = null) {
        }

        int executeCommand(ICommand acommand, Json[string] commandArguments = null,  ? IConsoleIo aConsoleIo = null) {
            auto myConsoleIo = aConsoleIo ?  : new DConsoleIo();

            try {
                return acommand.run(commandArguments, myConsoleIo);
            }
 catch (StopException anException) {
                return anException.getCode();
            }
        }
    } */ 
}
