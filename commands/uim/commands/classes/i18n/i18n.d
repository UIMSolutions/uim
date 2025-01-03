/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
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
    ulong execute(Json[string] arguments, IConsoleIo consoleIo) {
        consoleIo.writeln("<info>I18n Command</info>");
        consoleIo.hr();
        consoleIo.writeln("[E]xtract POT file from sources");
        consoleIo.writeln("[I]nitialize a language from POT file");
        consoleIo.writeln("[H]elp");
        consoleIo.writeln("[Q]uit");

        do {
            string choice = consoleIo.askChoice("What would you like to do?", [
                    "E", "I", "H", "Q"
                ])
                .lower;
            auto code = null;
            switch (choice) {
            case "e":
                code = executeCommand(I18nExtractCommand.classname, [], consoleIo);
                break;
            case "i":
                code = executeCommand(I18nInitCommand.classname, [], consoleIo);
                break;
            case "h":
                consoleIo.writeln(getOptionParser().help());
                break;
            case "q": // Do nothing
                break;
            default:
                consoleIo.writeErrorMessages(
                    "You have made an invalid selection. " ~
                        "Please choose a command to execute by entering E, I, H, or Q."
                );
            }
            if (code == CODE_ERROR) {
                abort();
            }
        }
        while (choice != "q");

        return CODE_SUCCESS;
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
