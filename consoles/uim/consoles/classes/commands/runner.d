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

    /**
     * Constructor
     *
     * consoleApp - The application to run CLI commands for.
     * @param \UIM\Console\ICommandFactory|null factory Command factory instance.
     * /
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
     * /
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
     * @param \UIM\Console\ConsoleIo|null  aConsoleIo The ConsoleIo instance. Used primarily for testing.
     * /
    int run(Json[string] argv, IConsoleIo aConsoleIo = null) {
        assert(!argv.isEmpty, "Cannot run any commands. No arguments received.");

        this.bootstrap();

        auto myCommands = new DCommandCollection([
            "help": HelpCommand.classname,
        ]);
        if (class_exists(VersionCommand.classname)) {
            myCommands.add("version", VersionCommand.classname);
        }
        myCommands = this.app.console(myCommands);

        if (cast(IPluginApplication)this.app) {
            myCommands = this.app.pluginConsole(myCommands);
        }
        this.dispatchEvent("Console.buildCommands", ["commands": myCommands]);
        this.loadRoutes();

        // Remove the root executable segment
        array_shift(argv);

        aConsoleIo = aConsoleIo ?aConsoleIo : new DConsoleIo();

        try {
            [name, argv] = this.longestCommandName(myCommands, argv);
            name = this.resolveName(myCommands,  aConsoleIo, name);
        } catch (MissingOptionException  anException) {
             aConsoleIo.error(anException.getFullMessage());

            return ICommand.CODE_ERROR;
        }
        auto command = this.getCommand(aConsoleIo, myCommands, name);
        
        auto result = this.runCommand(command, argv,  aConsoleIo);
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
     * /
    protected void bootstrap() {
        this.app.bootstrap();
        if (cast(IPluginApplication)this.app) {
            this.app.pluginBootstrap();
        }
    }
    
    // Get the application`s event manager or the global one.
    IEventManager getEventManager() {
        if (cast(IPluginApplication)this.app) {
            return _app.getEventManager();
        }
        return EventManager.instance();
    }
    
    // Set the application`s event manager.
    void setEventManager(IEventManager newEventManager) {
        assert(
            cast(IEventDispatcher)this.app,
            "Cannot set the event manager, the application does not support events."
        );

        this.app.setEventManager(newEventManager);
    }
    
    /**
     * Get the shell instance for a given command name
     * Params:
     * \UIM\Console\IConsoleIo aConsoleIo The IO wrapper for the created shell class.
     * @param \UIM\Console\CommandCollection commands The command collection to find the shell in.
     * @param string aName The command name to find
     * /
    protected ICommand getCommand(IConsoleIo aConsoleIo, CommandCollection commands, string commandName) {
        auto anInstance = commands.get(commandName);
        if (isString(anInstance)) {
             anInstance = this.createCommand(anInstance);
        }
         anInstance.name("{this.root} %s".format(commandName));

        if (cast(ICommandCollectionAware) anInstance) {
             anInstance.setCommandCollection(commands);
        }
        return anInstance;
    }
    
    /**
     * Build the longest command name that exists in the collection
     *
     * Build the longest command name that matches a
     * defined command. This will traverse a maximum of 3 tokens.
     * Params:
     * \UIM\Console\CommandCollection commands The command collection to check.
     * @param Json[string] argv The CLI arguments.
     * /
    // TODO protected Json[string] longestCommandName(CommandCollection commands, Json[string] argv) {
        for (anI = 3;  anI > 1;  anI--) {
            someParts = array_slice(argv, 0,  anI);
            name = someParts.join(" ");
            if (commands.has(name)) {
                return [name, array_slice(argv,  anI)];
            }
        }
        name = array_shift(argv);

        return [name, argv];
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
     * @param \UIM\Console\IConsoleIo aConsoleIo ConsoleIo object for errors.
     * @param string name The name from the CLI args.
     * /
    protected string resolveName(CommandCollection commands, IConsoleIo aConsoleIo, string aName) {
        if (!name) {
             aConsoleIo.writeErrorMessages("<error>No command provided. Choose one of the available commands.</error>", 2);
            name = "help";
        }
        name = _aliases[name] ?? name;
        if (!commands.has(name)) {
            name = Inflector.underscore(name);
        }
        if (!commands.has(name)) {
            throw new DMissingOptionException(
                "Unknown command `{this.root} {name}`. " .
                "Run `{this.root} --help` to get the list of commands.",
                name,
                commands.keys()
            );
        }
        return name;
    }
    
    /**
     * Execute a Command class.
     * Params:
     * \UIM\Console\ICommand command The command to run.
     * @param Json[string] argv The CLI arguments to invoke.
     * /
    protected int runCommand(ICommand command, Json[string] argv, IConsoleIo aConsoleIo) {
        try {
            if (cast(IEventDispatcher)command) {
                command.setEventManager(this.getEventManager());
            }
            return command.run(argv,  aConsoleIo);
        } catch (StopException  anException) {
            return anException.getCode();
        }
    }
    
    // The wrapper for creating command instances.
    protected ICommand createCommand(string className) {
        if (!this.factory) {
            container = null;
            if (cast(IContainerApplication)this.app) {
                container = this.app.getContainer();
            }
            this.factory = new DCommandFactory(container);
        }
        return _factory.create(className);
    }
    
    /**
     * Ensure that the application`s routes are loaded.
     * Console commands and shells often need to generate URLs.
     * /
    protected void loadRoutes() {
        if (!(cast(IRoutingApplication)this.app)) {
            return;
        }
        builder = Router.createRouteBuilder("/");

        this.app.routes(builder);
        if (cast(IPluginApplication)this.app) {
            this.app.pluginRoutes(builder);
        }
    } */
}
