module uim.consoles.classes.commands.runner;

import uim.consoles;

@safe:

/**
 * Run CLI commands for the provided application.
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\Core\IConsoleApplication>
 */
class DCommandRunner { // }: IEventDispatcher {
    mixin TConfigurable;
    // @use \UIM\Event\EventDispatcherTrait<\UIM\Core\IConsoleApplication>
    mixin TEventDispatcher;

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

    // The application console commands are being run for.
    protected IConsoleApplication _app;

    // The application console commands are being run for.
    protected DCommandFactory _factory = null;

    // The root command name. 
    protected string _rootCommandName = "uim";

    // Alias mappings.
    protected string[] _aliases;

    // consoleApp - The application to run CLI commands for.
    this(
        IConsoleApplication consoleApp,
        string rootCommandName = "uim",
        ICommandFactory commandFactory = null
   ) {
        _app = consoleApp;
        _rootCommandName = _rootCommandName;
        _factory = commandFactory;
        _aliases = [
            "--version": "version",
            "--help": "help",
            "-h": "help",
        ];
    }

    /**
     * Replace the entire alias map for a runner.
     *
     * Aliases allow you to define alternate names for commands
     * in the collection. This can be useful to add top level switches
     * like `--version` or `-h`
     *
     * ### Usage
     *
     * ```
     * runner.setAliases(["--version": 'version"]);
     * ```
     */
    void setAliases(string[] aliasesToReplace) {
        _aliases = aliasesToReplace;
    }

    /**
     * Run the command contained in argv.
     *
     * Use the application to do the following:
     *
     * - Bootstrap the application
     * - Create the CommandCollection using the console() hook on the application.
     * - Trigger the `Console.buildCommands` event of auto-wiring plugins.
     * - Run the requested command.
     * Params:
     * Json[string] argv The arguments from the CLI environment.
     */
    int run(Json[string] argv, IConsoleIo aConsoleIo = null) {
        assert(!argv.isEmpty, "Cannot run any commands. No arguments received.");

        bootstrap();

        auto myCommands = new DCommandCollection([
            "help": HelpCommand.classname,
        ]);
        if (class_exists(VersionCommand.classname)) {
            myCommands.add("version", VersionCommand.classname);
        }
        myCommands = _app.console(myCommands);

        if (cast(IPluginApplication) _app) {
            myCommands = _app.pluginConsole(myCommands);
        }
        dispatchEvent("Console.buildCommands", ["commands": myCommands]);
        this.loadRoutes();

        // Remove the root executable segment
        array_shift(argv);

        aConsoleIo = aConsoleIo ? aConsoleIo : new DConsoleIo();

        try {
            [name, argv] = this.longestCommandName(myCommands, argv);
            name = this.resolveName(myCommands, aConsoleIo, name);
        } catch (MissingOptionException anException) {
            aConsoleIo.error(anException.getFullMessage());

            return ICommand.CODE_ERROR;
        }
        auto command = getCommand(aConsoleIo, myCommands, name);

        auto result = this.runCommand(command, argv, aConsoleIo);
        if (result.isNull) {
            return ICommand.CODE_SUCCESS;
        }
        if (result >= 0 && result <= 255) {
            return result;
        }
        return ICommand.CODE_ERROR;
    }

    /**
     * Application bootstrap wrapper.
     *
     * Calls the application`s `bootstrap()` hook. After the application the
     * plugins are bootstrapped.
     */
    protected void bootstrap() {
        _app.bootstrap();
        if (cast(IPluginApplication) _app) {
            _app.pluginBootstrap();
        }
    }

    // Get the application`s event manager or the global one.
    IEventManager getEventManager() {
        if (cast(IPluginApplication) _app) {
            return _app.getEventManager();
        }
        return EventManager.instance();
    }

    // Set the application`s event manager.
    void setEventManager(IEventManager newEventManager) {
        assert(
            cast(IEventDispatcher) _app,
            "Cannot set the event manager, the application does not support events."
       );

        _app.setEventManager(newEventManager);
    }

    // Get the shell instance for a given command name
    protected ICommand getCommand(IConsoleIo aConsoleIo, CommandCollection commands, string commandName) {
        auto anInstance = commands.get(commandName);
        if (isString(anInstance)) {
            anInstance = this.createCommand(anInstance);
        }
        anInstance.name("{this.root} %s".format(commandName));

        if (cast(ICommandCollectionAware) anInstance) {
            anInstance.commandCollection(commands);
        }
        return anInstance;
    }

    /**
     * Build the longest command name that exists in the collection
     *
     * Build the longest command name that matches a
     * defined command. This will traverse a maximum of 3 tokens.
     */
    protected Json[string] longestCommandName(CommandCollection commandsToCheck, Json[string] cliArguments) {
        for (anI = 3; anI > 1; anI--) {
            someParts = array_slice(cliArguments, 0, anI);
            name = someParts.join(" ");
            if (commandsToCheck.has(name)) {
                return [name, array_slice(cliArguments, anI)];
            }
        }
        name = array_shift(cliArguments);

        return [name, cliArguments];
    }

    /**
     * Resolve the command name into a name that exists in the collection.
     *
     * Apply backwards compatible inflections and aliases.
     * Will step forward up to 3 tokens in argv to generate
     * a command name in the CommandCollection. More specific
     * command names take precedence over less specific ones.
     * Params:
     * \UIM\Console\CommandCollection commands The command collection to check.
     */
    protected string resolveName(CommandCollection comandsToCheck, IConsoleIo aConsoleIo, string cliArgumentName) {
        if (!cliArgumentName) {
            aConsoleIo.writeErrorMessages(
                "<error>No command provided. Choose one of the available commands.</error>", 2);
            cliArgumentName = "help";
        }

        string cliArgumentName = _aliases.getString(cliArgumentName, cliArgumentName);
        if (!comandsToCheck.has(cliArgumentName)) {
            cliArgumentName = Inflector.underscore(cliArgumentName);
        }
        if (!comandsToCheck.has(cliArgumentName)) {
            throw new DMissingOptionException(
                "Unknown command `{this.root} {cliArgumentName}`. "~
                "Run `{this.root} --help` to get the list of commands.".format(
                cliArgumentName, comandsToCheck.keys()));
        }
        return cliArgumentName;
    }

    /**
     * Execute a Command class.
     * Params:
     * \UIM\Console\ICommand command The command to run.
     */
    protected int runCommand(ICommand command, Json[string] argumentsToInvoke, IConsoleIo aConsoleIo) {
        try {
            if (cast(IEventDispatcher) command) {
                command.setEventManager(getEventManager());
            }
            return command.run(argumentsToInvoke, aConsoleIo);
        } catch (StopException anException) {
            return anException.code();
        }
    }

    // The wrapper for creating command instances.
    protected ICommand createCommand(string className) {
        if (!this.factory) {
            container = null;
            if (cast(IContainerApplication) this.app) {
                container = _app.getContainer();
            }
            this.factory = new DCommandFactory(container);
        }
        return _factory.create(className);
    }

    /**
     * Ensure that the application`s routes are loaded.
     * Console commands and shells often need to generate URLs.
     */
    protected void loadRoutes() {
        if (!(cast(IRoutingApplication) this.app)) {
            return;
        }
        builder = Router.createRouteBuilder("/");

        _app.routes(builder);
        if (cast(IPluginApplication) this.app) {
            _app.pluginRoutes(builder);
        }
    }
}
