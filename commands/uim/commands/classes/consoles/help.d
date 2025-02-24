/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.consoles.help;

import uim.commands;
@safe:

version (test_uim_commands) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// Print out command list
class DHelpCommand : DConsoleCommand { // }, ICommandCollectionAware {
  // The command collection to get help on.
  protected DCommandCollection _commands;
  void commandCollection(DCommandCollection newCommands) {
    _commands = newCommands;
  }

  // Main auto Prints out the list of commands.
  override bool execute(Json[string] arguments, IConsole console = null) {
    /*         auto commandIterator = _commands.getIterator();
        if (cast(DArrayIterator) commandIterator) {
            commandIterator.ksort();
        }
        if (commandArguments.getOption("xml")) {
            this.asXml(console, commandIterator);

            return true;
        }
        asText(console, commandIterator);
    */
    return true;
  }

  // Output text.
  protected void asText(DConsole console, string[string] commands) {
    string[][string] inverts = null;
    /* commands.byKeyValue
      .map!(nameCommand => nameCommand.value.classname)
      .each!(classname => inverts.require(classname, null)); */
    // inverts[classname).concat(name);

    auto anGrouped = null;
    /* auto plugins = Plugin.loaded(); */
    inverts.byKeyValue.each!((classname) {
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

            string shortestName = shortestText(names);
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

    /* outputPaths(console);
        console.out("<info>Available Commands:</info>", 2);
 */
    /* foreach (prefix, names;  anGrouped) {
            console.out("<info>%s</info>:".format(prefix));
            auto sortedNames = names.sort;
            foreach (someData; sortedNames) {
                 console.out(" - " ~ someData.getString("name"));
                if (auto description = someData.get("description", null)) {
                     console.info(str_pad(" \u{2514}", 13, "\u{2500}") ~ " " ~ description.get!string);
                }
            }
             console.out("");
        } */
    string root = rootName();
    /*        console.out("To run a command, type <info>`{root} command_name [args|options]`</info>");
        console.out("To get help on a specific command, type <info>`{root} command_name --help`</info>", 2);
 */
  }

  // Output relevant paths if defined
  protected void outputPaths(DConsole console) {
    STRINGAA myPaths;

    if (configuration.hasKey("App.dir")) {
      string appPath = stripRight(configuration.getString("App.dir"), DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
      // Extra space is to align output
      myPaths.set("app", " " ~ appPath);
    }
    /* if (defined("ROOT")) {
            myPaths.set("root", stripRight(ROOT, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR);
        }
        if (defined("CORE_PATH")) {
            myPaths.set("core", stripRight(CORE_PATH, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR);
        }
        if (!count(myPaths)) {
            return;
        } */
    /*         console.out("<info>Current Paths:</info>", 2);
        myPaths.each!(kv => console.out("* %s: %s".format(kv.key, kv.value)));
         console.out(""); */
  }

  // Output as XML
  protected void asXml(DConsole console, DCommand[string] commands) {
    STRINGAA names;
    /* commands.byKeyValue
            .each!(nameCommand => names[nameCommand.key] = nameCommand.value); */

    /*         asXml(console, names); */
  }

  /* protected void asXml(DConsole console, string[string] commandNames) {
        auto shells = new DSimpleXMLElement("<shells></shells>");
        commandNames.byKeyValue
            .each(nameclassname => shells.addCommandToShells(nameclassname.key, nameclassname.value));

        /*        console.setOutputAs(DOutput.RAW);
        console.out(castto!string(xmlShells.saveXML())); * /
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
