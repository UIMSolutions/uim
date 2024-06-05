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
     * Params:
     * \UIM\Console\Json[string] arguments The command arguments.
     */
    protected void startup(Json[string] arguments, IConsoleIo aConsoleIo) {
        _host = arguments.getString("host", _host); 

        _port = arguments.getInt("port", _port));

        if (arguments.hasKey("document_root")) {
           _documentRoot = arguments.getString("document_root");
        }
        if (commandArguments.getOption("ini_path")) {
           _iniPath = arguments.getString("ini_path"));
        }
        // For Windows
        if (substr(_documentRoot, -1, 1) == DIRECTORY_SEPARATOR) {
           _documentRoot = substr(_documentRoot, 0, _documentRoot.length - 1);
        }
        if (preg_match("/^([a-z]:)[\\\]+(.+)$/i", _documentRoot, m)) {
           _documentRoot = m[1] ~ "\\" ~ m[2];
        }
       _iniPath = stripRight(_iniPath, DIRECTORY_SEPARATOR);
        if (preg_match("/^([a-z]:)[\\\]+(.+)$/i", _iniPath, m)) {
           _iniPath = m[1] ~ "\\" ~ m[2];
        }
         aConsoleIo.writeln();
         aConsoleIo.writeln("<info>Welcome to UIM %s Console</info>".format("v" ~ Configure.currentVersion()));
         aConsoleIo.hr();
         aConsoleIo.writeln("App : %s".format(configuration.get("App.dir")));
         aConsoleIo.writeln("Path: %s".format(APP));
         aConsoleIo.writeln("DocumentRoot: %s".format(_documentRoot));
         aConsoleIo.writeln("Ini Path: %s".format(_iniPath));
         aConsoleIo.hr();
    }

  overwrite int execute(Json[string] arguments, IConsoleIo aConsoleIo) {
        this.startup(commandArguments,  aConsoleIo);
        DBinary = to!string(enviroment("D", "d"));
        string commandText = "%s -S %s:%d -t %s"
            .format(
                DBinary,
                _host,
                _port,
                escapeshellarg(_documentRoot)
           );

        if (!_iniPath.isEmpty) {
            commandText = "%s -c %s".format(commandText, _iniPath);
        }
        commandText = "%s %s".format(commandText, escapeshellarg(_documentRoot ~ "/index.d"));

        string port = ": " ~ _port;
         aConsoleIo.writeln("built-in server is running in http://%s%s/".format(_host, port));
         aConsoleIo.writeln("You can exit with <info>`CTRL-C`</info>");
        system(commandText);

        return CODE_SUCCESS;
    }
    
    /**
     * Hook method for defining this command`s option parser.
     */
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        with (parserToUpdate) {
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
        }

        return aParser;
    }
}
