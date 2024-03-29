module uim.commands.classes.commands.i18n.i18n;

import uim.commands;

@safe:

// Command for interactive I18N management.
class DI18nCommand : DCommand {
    mixin(CommandThis!("I18n"));

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    /*
    // Execute interactive mode
    int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        aConsoleIo.writeln("<info>I18n Command</info>");
        aConsoleIo.hr();
        aConsoleIo.writeln("[E]xtract POT file from sources");
        aConsoleIo.writeln("[I]nitialize a language from POT file");
        aConsoleIo.writeln("[H]elp");
        aConsoleIo.writeln("[Q]uit");

        do {
            string choice = aConsoleIo.askChoice("What would you like to do?", ["E", "I", "H", "Q"])
                .toLower;
            code = null;
            switch (choice) {
            case "e" : code = this.executeCommand(I18nExtractCommand.classname, [], aConsoleIo);
                break;
            case "i" : code = this.executeCommand(I18nInitCommand.classname, [], aConsoleIo);
                break;
            case "h" : aConsoleIo.writeln(this.getOptionParser().help());
                break;
            case "q" : // Do nothing
                break;
            default : aConsoleIo.writeErrorMessages(
                    "You have made an invalid selection. " ~
                        "Please choose a command to execute by entering E, I, H, or Q."
                );
            }
            if (code == CODE_ERROR) {
                this.abort();
            }
        }
        while (choice != "q");

        return CODE_SUCCESS;
    }

    //  Gets the option parser instance and configures it.
    ConsoleOptionParser buildOptionParser(ConsoleOptionParser parserToUpdate) {
        parserToUpdate.description(
            "I18n commands let you generate .pot files to power translations in your application."
        );

        return aParser;
    } */
}

mixin(CommandCalls!("I18n"));
