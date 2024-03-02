module uim.consoles.classes.commands.help;

import uim.consoles;

@safe:

// Print out command list
class HelpCommand : Command, ICommandCollectionAware {
    // The command collection to get help on.
    protected CommandCollection _commands;

    void setCommandCollection(CommandCollection newCommands) {
        _commands = newCommands;
    }
    
    // Main auto Prints out the list of commands.
    int execute(Arguments commandArguments, ConsoleIo aConsoleIo) {
        auto myCommands = this.commands.getIterator();
        if (cast(ArrayIterator)myCommands) {
            myCommands.ksort();
        }
        if (commandArguments.getOption("xml")) {
            this.asXml(aConsoleIo, myCommands);

            return CODE_SUCCESS;
        }
        this.asText(aConsoleIo, myCommands);

        return CODE_SUCCESS;
    }
    
    /**
     * Output text.
     * @param iterable<string, string|object> $commands The command collection to output.
     */
    protected void asText(ConsoleIo aConsoleIo, STRINGAA commands) {
        string[][string] myInvert = [];
        foreach (name, className; commands) {
            /* if (isObject(className)) {
                 className = className.class;
            }*/
            myInvert.require(className, null);
            myInvert[className] ~= name;
        }
        
        auto anGrouped = [];
        auto plugins = Plugin.loaded();
        foreach (className, names; myInvert) {
            preg_match("/^(.+)\\\\Command\\\\/",  className, matches);
            // Probably not a useful class
            if (matches.isEmpty) { continue; }
            
            string namespace = matches[1].replace("\\", "/");
            
            string prefix = "App";
            if (namespace == "UIM") {
                prefix = "UIM";
            } elseif (namespace.has(plugins)) {
                prefix = namespace;
            }

            string shortestName = this.getShortestName(names);
            if (shortestName.has(".")) {
                auto names = shortestName.split(".");
                if (names > 1) { shortestName = names[1..$].join("."); }
            }
            anGrouped[prefix] ~= [
                "name": shortestName,
                "description": isSubclass_of(className, BaseCommand.class) 
                    ?  className.getDescription()
                    : ""
            ];
        }
        ksort(anGrouped);

        this.outputPaths(aConsoleIo);
        aConsoleIo.out("<info>Available Commands:</info>", 2);

        foreach (prefix, names;  anGrouped) {
            aConsoleIo.out("<info>%s</info>:".format(prefix));
            auto sortedNames = names.sort;
            foreach (someData; sortedNames) {
                 aConsoleIo.out(" - " ~ someData["name"]);
                if (auto description = someData.get("description", null)) {
                     aConsoleIo.info(str_pad(" \u{2514}", 13, "\u{2500}") ~ " " ~ description.get!string);
                }
            }
             aConsoleIo.out("");
        }
        $root = this.getRootName();

        aConsoleIo.out("To run a command, type <info>`{$root} command_name [args|options]`</info>");
        aConsoleIo.out("To get help on a specific command, type <info>`{$root} command_name --help`</info>", 2);
    }
    
    // Output relevant paths if defined
    protected void outputPaths(ConsoleIo aConsoleIo) {
        STRINGAA myPaths;
        if (Configure::check("App.dir")) {
            string appPath = rtrim(Configure::read("App.dir"), DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
            // Extra space is to align output
            myPaths["app"] = " " ~ appPath;
        }
        if (defined("ROOT")) {
            myPaths["root"] = rtrim(ROOT, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
        }
        if (defined("CORE_PATH")) {
            myPaths["core"] = rtrim(CORE_PATH, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
        }
        if (!count(myPaths)) {
            return;
        }
         aConsoleIo.out("<info>Current Paths:</info>", 2);
        myPaths.each!(kv => aConsoleIo.out("* %s: %s".format(kv.key, kv.value)));
         aConsoleIo.out("");
    }
    
    // @param string[] names Names
    protected string getShortestName(string[] names) {
        if (names.isEmpty) { return null; }
        if (names.length == 1) { return names[0]; }

        names = names.sort("a.length < b.length");
        return names[0];
    }
    
    // Output as XML
    protected void asXml(ConsoleIo aConsoleIo, ICommand[string] commands) {
        STRINGAA names = commands.byKeyValue
            .each(nameCommand => names[nameCommand.key] = nameCommand.value);

        asXml(aConsoleIo, names);   
    }
    
    protected void asXml(ConsoleIo aConsoleIo, string[string] commandNames) {
        auto shells = new SimpleXMLElement("<shells></shells>");
        commandNames.byKeyValue
            .each(nameClassname => shells.addCommandToShells(nameClassname.key, nameClassname.value));

        aConsoleIo.setOutputAs(ConsoleOutput.RAW);
        aConsoleIo.out(cast(string)xmlShells.saveXML());
    }

    void addCommandToShells(SimpleXMLElement shells, string commandName, ICommand command) {
        addCommandToShells(shells, commandName, command.classname) {
    }

    void addCommandToShells(SimpleXMLElement shells, string commandName, string commandClassname) {
        auto shell = shells.addChild("shell");
        shell.addAttribute("name", commandName);
        shell.addAttribute("call_as", commandName);
        shell.addAttribute("provider", commandClassname);
        shell.addAttribute("help", commandName ~ " -h");
    }
    
    // Gets the option parser instance and configures it.
    protected ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToBuild) {
        parserToBuild.description("Get the list of available commands for this application.");

        auto addOption = Json.emptyObject;
        addOption["help"] = "Get the listing as XML.";
        addOption["boolean"] = true; 
        parserToBuild.addOption("xml", addOption);

        return parserToBuild;
    }
}
