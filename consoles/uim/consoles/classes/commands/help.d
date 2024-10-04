/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.commands.help;

import uim.consoles;

@safe:

// Print out command list
class DHelpCommand : DConsoleCommand { // }, ICommandCollectionAware {
    // The command collection to get help on.
    protected DCommandCollection _commands;
    void commandCollection(DCommandCollection newCommands) {
        _commands = newCommands;
    }

    // Main auto Prints out the list of commands.
    override ulong execute(Json[string] arguments, DConsoleIo aConsoleIo) {
        /*         auto commandIterator = _commands.getIterator();
        if (cast(DArrayIterator) commandIterator) {
            commandIterator.ksort();
        }
        if (commandArguments.getOption("xml")) {
            this.asXml(aConsoleIo, commandIterator);

            return CODE_SUCCESS;
        }
        asText(aConsoleIo, commandIterator);

        return CODE_SUCCESS;
 */
        return 0;
    }

    // Output text.
    protected void asText(DConsoleIo aConsoleIo, string[string] commandCollection) {
        string[][string] myInvert = null;
        /*  foreach (name, classname; commands) {
            /* if (isObject(classname)) {
                 classname = classname.classname;
            }* /
           /*  myInvert.require(classname, null);
            myInvert[classname).concat( name; * /
        } */

        auto anGrouped = null;
        /* auto plugins = Plugin.loaded(); */
        myInvert.byKeyValue.each!((classname) {
            // preg_match("/^(.+)\\\\Command\\\\/",  classname, matches);
            // Probably not a useful class
            /*            if (matches.isEmpty) { continue; }
            
            string namespace = matches[1].replace("\\", "/");
            
            string prefix = "App";
            if (namespace == "UIM") {
                prefix = "UIM";
            } else if (namespace.has(plugins)) {
                prefix = namespace;
            }

            string shortestName = getShortestName(names);
            if (shortestName.contains(".")) {
                string[] names = shortestName.split(".");
                if (names > 1) { shortestName = names[1..$].join("."); }
            }
            anGrouped[prefix).concat( [
                "name": shortestName,
                "description": isSubclass_of(classname, BaseCommand.classname) 
                    ?  classname.getDescription()
                    : ""
            ];
 */
        });
        // ksort(anGrouped);

        /* outputPaths(aConsoleIo);
        aConsoleIo.out("<info>Available Commands:</info>", 2);
 */
        /* foreach (prefix, names;  anGrouped) {
            aConsoleIo.out("<info>%s</info>:".format(prefix));
            auto sortedNames = names.sort;
            foreach (someData; sortedNames) {
                 aConsoleIo.out(" - " ~ someData.getString("name"));
                if (auto description = someData.get("description", null)) {
                     aConsoleIo.info(str_pad(" \u{2514}", 13, "\u{2500}") ~ " " ~ description.get!string);
                }
            }
             aConsoleIo.out("");
        } */
        string root = rootName();
        /*        aConsoleIo.out("To run a command, type <info>`{root} command_name [args|options]`</info>");
        aConsoleIo.out("To get help on a specific command, type <info>`{root} command_name --help`</info>", 2);
 */
    }

    // Output relevant paths if defined
    protected void outputPaths(DConsoleIo aConsoleIo) {
        STRINGAA myPaths;
        /* if (configuration.check("App.dir")) {
            /* string appPath = stripRight(configuration.read("App.dir"), DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
            // Extra space is to align output
            myPaths.set("app", " " ~ appPath); * /
        } */
        /* if (defined("ROOT")) {
            myPaths.set("root", stripRight(ROOT, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR);
        }
        if (defined("CORE_PATH")) {
            myPaths.set("core", stripRight(CORE_PATH, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR);
        }
        if (!count(myPaths)) {
            return;
        } */
        /*         aConsoleIo.out("<info>Current Paths:</info>", 2);
        myPaths.each!(kv => aConsoleIo.out("* %s: %s".format(kv.key, kv.value)));
         aConsoleIo.out(""); */
    }

    protected string getShortestName(string[] names) {
        if (names.isEmpty) {
            return null;
        }
        if (names.length == 1) {
            return names[0];
        }

        /* auto names = names.sort!("a.length < b.length");
        return names[0]; */
        return null;
    }

    // Output as XML
    protected void asXml(DConsoleIo aConsoleIo, DCommand[string] commands) {
        STRINGAA names;
        /* commands.byKeyValue
            .each!(nameCommand => names[nameCommand.key] = nameCommand.value); */

        /*         asXml(aConsoleIo, names); */
    }

    /* protected void asXml(DConsoleIo aConsoleIo, string[string] commandNames) {
        auto shells = new DSimpleXMLElement("<shells></shells>");
        commandNames.byKeyValue
            .each(nameclassname => shells.addCommandToShells(nameclassname.key, nameclassname.value));

        /*        aConsoleIo.setOutputAs(DOutputConsole.RAW);
        aConsoleIo.out(castto!string(xmlShells.saveXML())); * /
    } */

    // TODO
    /*    void addCommandToShells(DSimpleXMLElement shells, string commandName, DCommand command) {
        addCommandToShells(shells, commandName, command.classname);
    } */

    /* void addCommandToShells(DSimpleXMLElement shells, string commandName, string commandclassname) {
        auto shell = shells.addChild("shell");
        shell.addAttribute("name", commandName);
        shell.addAttribute("call_as", commandName);
        shell.addAttribute("provider", commandclassname);
        shell.addAttribute("help", commandName ~ " -h");
    } */

    // Gets the option parser instance and configurations it.
    override protected IConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToBuild) {
        /* parserToBuild.description("Get the list of available commands for this application.");

        auto addOption = Json.emptyObject;
        addOption.set("help", "Get the listing as XML.");
        addOption.set("boolean", true); */
        /*         parserToBuild.addOption("xml", addOption); */

        // return parserToBuild;
        return null;
    }
}
