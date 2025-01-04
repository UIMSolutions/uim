/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.server;

import uim.commands;

@safe:

// built-in Server command
class DServerCommand : DCommand {
    mixin(CommandThis!("Server"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // Default ServerHost
    const string DEFAULT_HOST = "localhost";

    // Default ListenPort
    const int DEFAULT_PORT = 8765;

    // server host
    protected string _host = DEFAULT_HOST;

    // listen port
    protected int _port = DEFAULT_PORT;

    // document root
    protected string _documentRoot; // TODO = WWW_ROOT;

    // ini path
    protected string _iniPath = "";

    /**
     * Starts up the Command and displays the welcome message.
     * Allows for checking and configuring prior to command or main execution
     */
    /* protected void startup(Json[string] arguments, IConsole aConsole) {
        _host = arguments.getString("host", _host);
        _port = arguments.getLong("port", _port);
        if (arguments.hasKey("document_root")) {
            _documentRoot = arguments.getString("document_root");
        }
        if (commandArguments.getOption("ini_path")) {
            _iniPath = arguments.getString("ini_path");
        }
        // For Windows
        if (_documentRoot.subString(-1, 1) == DIRECTORY_SEPARATOR) {
            _documentRoot = _documentRoot.subString(0, _documentRoot.length - 1);
        }
        /*         if (preg_match("/^([a-z]:)[\\\]+(.+)$/i", _documentRoot, m)) {
           _documentRoot = m[1] ~ "\\" ~ m[2];
        }
 * /
        _iniPath = stripRight(_iniPath, DIRECTORY_SEPARATOR);
        /* if (preg_match("/^([a-z]:)[\\\]+(.+)$/i", _iniPath, m)) {
           _iniPath = m[1] ~ "\\" ~ m[2];
        }
        with (aConsole) {
            writeln();
            writeln("<info>Welcome to UIM %s Console</info>".format("v" ~ Configure.currentVersion()));
            hr();
            writeln("App : %s".format(configuration.get("App.dir")));
            writeln("Path: %s".format(APP));
            writeln("DocumentRoot: %s".format(_documentRoot));
            writeln("Ini Path: %s".format(_iniPath));
            hr();
        } * /
    } */

    override bool execute(Json[string] arguments, IConsole console = null) {
        /* 
        this.startup(commandArguments, console);
        DBinary = to!string(enviroment("D", "d"));
        string commandText = "%s -S %s:%d -t %s"
            .format(
                DBinary,
                _host,
                _port,
                escapeshellarg(_documentRoot)
            );

        /*         if (!_iniPath.isEmpty) {
            commandText = "%s -c %s".format(commandText, _iniPath);
        } * /
        commandText = "%s %s".format(commandText, escapeshellarg(_documentRoot ~ "/index.d"));

        /* string port = ": " ~ _port;
         console.writeln("built-in server is running in http://%s%s/".format(_host, port));
         console.writeln("You can exit with <info>`CTRL-C`</info>");
        system(commandText); */

        return true;
    } 

    // Hook method for defining this command`s option parser.
    /* DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) { */
        /* with (parserToUpdate) {
            description([
                "D Built-in Server for UIM",
                "<warning>[WARN] Don't use this in a production environment</warning>",
            ].join("\n"));
            
            addOption("host", [
                "short": "H",
                "help": "serverHost",
            ]);
            addOption("port", [
                "short": "p",
                "help": "ListenPort",
            ]);
            addOption("ini_path", [
                "short": "I",
                "help": "D.ini path",
            ]);
            addOption("document_root", [
                "short": "d",
                "help": "DocumentRoot",
            ]);
        } */

        /* return aParser;
    } */
}
