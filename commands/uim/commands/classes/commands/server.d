module uim.commands.server;

import uim.commands;

@safe:

// built-in Server command
class ServerCommand : DCommand {
   mixin(CommandThis!("ServerCommand"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}

    // Default ServerHost
    const string DEFAULT_HOST = "localhost";

    // Default ListenPort
    const int DEFAULT_PORT = 8765;

    // server host
    protected string _host = self.DEFAULT_HOST;

    // listen port
    protected int _port = self.DEFAULT_PORT;

    // document root
    protected string _documentRoot = WWW_ROOT;

    // ini path
    protected string _iniPath = "";

    /**
     * Starts up the Command and displays the welcome message.
     * Allows for checking and configuring prior to command or main execution
     * Params:
     * \UIM\Console\Arguments commandArguments The command arguments.
     * @param \UIM\Console\IConsoleIo aConsoleIo The console io
     * @link https://book.UIM.org/5/en/console-and-shells.html#hook-methods
     */
    protected void startup(Arguments commandArguments, IConsoleIo aConsoleIo) {
        if (commandArguments.getOption("host")) {
           _host = to!string(commandArguments.getOption("host"));
        }
        if (commandArguments.getOption("port")) {
           _port = to!int(commandArguments.getOption("port"));
        }
        if (commandArguments.getOption("document_root")) {
           _documentRoot = to!string(commandArguments.getOption("document_root"));
        }
        if (commandArguments.getOption("ini_path")) {
           _iniPath = to!string(commandArguments.getOption("ini_path"));
        }
        // For Windows
        if (substr(_documentRoot, -1, 1) == DIRECTORY_SEPARATOR) {
           _documentRoot = substr(_documentRoot, 0, _documentRoot.length - 1);
        }
        if (preg_match("/^([a-z]:)[\\\]+(.+)$/i", _documentRoot, m)) {
           _documentRoot = m[1] ~ "\\" ~ m[2];
        }
       _iniPath = rtrim(_iniPath, DIRECTORY_SEPARATOR);
        if (preg_match("/^([a-z]:)[\\\]+(.+)$/i", _iniPath, m)) {
           _iniPath = m[1] ~ "\\" ~ m[2];
        }
         aConsoleIo.writeln();
         aConsoleIo.writeln("<info>Welcome to UIM %s Console</info>".format("v" ~ Configure.currentVersion()));
         aConsoleIo.hr();
         aConsoleIo.writeln("App : %s".format(Configure.read("App.dir")));
         aConsoleIo.writeln("Path: %s".format(APP));
         aConsoleIo.writeln("DocumentRoot: %s".format(_documentRoot));
         aConsoleIo.writeln("Ini Path: %s".format(_iniPath));
         aConsoleIo.hr();
    }

  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        this.startup(commandArguments,  aConsoleIo);
        phpBinary = to!string(enviroment("PHP", "php"));
        string commandText = "%s -S %s:%d -t %s"
            .format(
                phpBinary,
                _host,
                _port,
                escapeshellarg(_documentRoot)
            );

        if (!_iniPath.isEmpty) {
            commandText = "%s -c %s".format(commandText, _iniPath);
        }
        commandText = "%s %s".format(commandText, escapeshellarg(_documentRoot ~ "/index.d"));

        string port = ":" ~ _port;
         aConsoleIo.writeln("built-in server is running in http://%s%s/".format(_host, port));
         aConsoleIo.writeln("You can exit with <info>`CTRL-C`</info>");
        system(commandText);

        return CODE_SUCCESS;
    }
    
    /**
     * Hook method for defining this command`s option parser.
     * Params:
     * \UIM\Console\ConsoleOptionParser  aParser The option parser to update
     */
    ConsoleOptionParser buildOptionParser(ConsoleOptionParser  aParser) {
         aParser.description([
            "PHP Built-in Server for UIM",
            "<warning>[WARN] Don\'t use this in a production environment</warning>",
        ]).addOption("host", [
            "short": 'H",
            "help": `serverHost",
        ]).addOption("port", [
            "short": 'p",
            "help": 'ListenPort",
        ]).addOption("ini_path", [
            "short": 'I",
            "help": 'php.ini path",
        ]).addOption("document_root", [
            "short": 'd",
            "help": 'DocumentRoot",
        ]);

        return aParser;
    }
}
