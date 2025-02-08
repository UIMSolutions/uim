/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.i18n.i18n;

import uim.commands;

@safe:

// Command for interactive I18N management.
class DI18nCommand : DCommand {
    mixin(CommandThis!("I18n"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // Execute interactive mode
    override bool execute(Json[string] arguments, IConsole console = null) {
        /* console.writeln("<info>I18n Command</info>");
        console.hr();
        console.writeln("[E]xtract POT file from sources");
        console.writeln("[I]nitialize a language from POT file");
        console.writeln("[H]elp");
        console.writeln("[Q]uit");

        do {
            string choice = console.askChoice("What would you like to do?", [
                    "E", "I", "H", "Q"
                ])
                .lower;
            auto code = null;
            switch (choice) {
            case "e":
                code = executeCommand(I18nExtractCommand.classname, [], console);
                break;
            case "i":
                code = executeCommand(I18nInitCommand.classname, [], console);
                break;
            case "h":
                console.writeln(getOptionParser().help());
                break;
            case "q": // Do nothing
                break;
            default:
                console.writeErrorMessages(
                    "You have made an invalid selection. " ~
                        "Please choose a command to execute by entering E, I, H, or Q."
                );
            }
            if (code == false) {
                abort();
            }
        }
        while (choice != "q"); */

        return true;
    }

    //  Gets the option parser instance and configures it.
    /* DConsoleOptionParser buildOptionParser(DConsoleOptionParser parserToUpdate) {
        parserToUpdate.description(
            "I18n commands let you generate .pot files to power translations in your application."
        );

        return aParser;
    } */
}

mixin(CommandCalls!("I18n"));
