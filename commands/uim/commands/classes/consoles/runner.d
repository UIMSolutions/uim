/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.runner;

import uim.commands;

@safe:

/**
 * Run CLI commands for the provided application.
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\Core\IConsoleApplication>
 */
class DCommandRunner : UIMObject { // }: IEventDispatcher {
    // @use \UIM\Event\EventDispatcherTrait<\UIM\Core\IConsoleApplication>
    mixin TEventDispatcher;

    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    // The application console commands are being run for.
    protected IConsoleApplication _app;

    // The application console commands are being run for.
    protected DCommandFactory _factory = null;

    // The root command name. 
    protected string _rootCommandName = "uim";

    // Alias mappings.
    protected string[] _aliases;

    // consoleApp - The application to run CLI commands for.
    /* this(
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
    } */

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
     * Run the command contained in arguments.
     *
     * Use the application to do the following:
     *
     * - Bootstrap the application
     * - Create the CommandCollection using the console() hook on the application.
     * - Trigger the `Console.buildCommands` event of auto-wiring plugins.
     * - Run the requested command.
     */
    ulong run(Json[string] arguments, DConsoleIo aConsoleIo = null) {
        assert(!arguments.isEmpty, "Cannot run any commands. No arguments received.");

        bootstrap();

        auto myCommands = new DCommandCollection( /* [
            "help": HelpCommand.classname,
        ] */
        
        );
        /*         if (class_hasKey(VersionCommand.classname)) {
            myCommands.add("version", VersionCommand.classname);
        }
 */ /* myCommands = _app.console(myCommands); */

        /* if (cast(IPluginApplication) _app) {
            myCommands = _app.pluginConsole(myCommands);
        } */
        /* dispatchEvent("Console.buildCommands", ["commands": myCommands]);
        loadRoutes(); */

        // Remove the root executable segment
        // TODO arguments.shift();
        aConsoleIo = aConsoleIo ? aConsoleIo : new DConsoleIo();

        /* try {
            [name, arguments] = this.longestCommandName(myCommands, arguments);
            name = this.resolveName(myCommands, aConsoleIo, name);
        } catch (MissingOptionException anException) {
            aConsoleIo.error(anException.getFullMessage());

            return ICommand.CODE_ERROR;
        } */
        auto command = getCommand(aConsoleIo, myCommands, name);

        auto result = this.runCommand(command, arguments, aConsoleIo);
        /* if (result.isNull) {
            return 0; // ICommand.CODE_SUCCESS;
        } */

        return result >= 0 && result <= 255
            ? result : 0; // ICommand.CODE_ERROR;
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
            // _app.pluginBootstrap();
        }
    }

    // Get the application`s event manager or the global one.
    IEventManager getEventManager() {
        if (cast(IPluginApplication) _app) {
            // return _app.getEventManager();
        }
        // return EventManager.instance();
        return null;
    }

    // Set the application`s event manager.
    void eventManager(IEventManager newEventManager) {
        assert(
            cast(IEventDispatcher) _app,
            "Cannot set the event manager, the application does not support events."
        );

        // _app.eventManager(newEventManager);
    }

    // Get the shell instance for a given command name
    protected ICommand getCommand(DConsoleIo aConsoleIo, DCommandCollection commands, string commandName) {
        /* auto anInstance = commands.get(commandName);
        if (isString(anInstance)) {
            anInstance = this.createCommand(anInstance);
        }
        anInstance.name("{this.root} %s".format(commandName));

        if (cast(ICommandCollectionAware) anInstance) {
            anInstance.commandCollection(commands);
        }
        return anInstance; */
        return null;
    }

    /**
     * Build the longest command name that exists in the collection
     *
     * Build the longest command name that matches a
     * defined command. This will traverse a maximum of 3 tokens.
     */
    protected Json[string] longestCommandName(DCommandCollection commandsToCheck, Json[string] cliArguments) {
        /* for (index = 3; index > 1; index--) {
            someParts = cliArguments.slice(0, index);
            name = someParts.join(" ");
            if (commandsToCheck.has(name)) {
                return [name, cliArguments.slice(index)];
            }
        }
        name = cliArguments.shift();

        return [name, cliArguments]; */
        return null;
    }

    /**
     * Resolve the command name into a name that exists in the collection.
     *
     * Apply backwards compatible inflections and aliases.
     * Will step forward up to 3 tokens in arguments to generate
     * a command name in the CommandCollection. More specific
     * command names take precedence over less specific ones.
     */
    protected string resolveName(DCommandCollection comandsToCheck, DConsoleIo aConsoleIo, string cliArgumentName) {
        if (!cliArgumentName) {
            /* aConsoleIo.writeErrorMessages(
                "<error>No command provided. Choose one of the available commands.</error>", 2);
            cliArgumentName = "help"; */
        }

        /* string cliArgumentName = _aliases.getString(cliArgumentName, cliArgumentName);
        if (!comandsToCheck.has(cliArgumentName)) {
            cliArgumentName = cliArgumentName.underscore;
        } */
        /* if (!comandsToCheck.has(cliArgumentName)) {
            throw new DMissingOptionException(
                "Unknown command `{this.root} {cliArgumentName}`. "~
                "Run `{this.root} --help` to get the list of commands.".format(
                cliArgumentName, comandsToCheck.keys()));
        } */
        /* return cliArgumentName; */
        return null;
    }

    // Execute a Command class.
    protected ulong runCommand(ICommand command, Json[string] argumentsToInvoke, DConsoleIo aConsoleIo) {
        /* try {
            if (cast(IEventDispatcher) command) {
                command.eventManager(getEventManager());
            }
            return command.run(argumentsToInvoke, aConsoleIo);
        } catch (StopException anException) {
            return anException.code();
        } */
        return 0;
    }

    // The wrapper for creating command instances.
    protected ICommand createCommand(string classname) {
        if (!_factory) {
            /* container = null;
            if (cast(IContainerApplication) _app) {
                container = _app.getContainer();
            }
            _factory = new DCommandFactory(container); */
        }
        /* return _factory.create(classname); */
        return null;
    }

    /**
     * Ensure that the application`s routes are loaded.
     * Console commands and shells often need to generate URLs.
     */
    protected void loadRoutes() {
        /* if (!(cast(IRoutingApplication)_app)) {
            return;
        } */

        /* auto builder = Router.createRouteBuilder("/"); */
        /* _app.routes(builder);
        if (cast(IPluginApplication)_app) {
            _app.pluginRoutes(builder);
        } */
    }
}
