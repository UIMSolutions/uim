/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.classes.commands.i18n.i18ninit;    if (!super.initialize(initData)) {UIMException
      return false;
    }

import uim.commands;

@safe:

// Command for interactive I18N management.
class DI18nInitCommand : DCommand {
   mixin(CommandThis!("I18nInit"));

    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }
    
    return true;
  }

    static string defaultName() {
        return "i18n-init";
    }

    ulong execute(Json[string] arguments, IConsoleIo consoleIo) {
        auto myLanguage = commandArguments.getArgument("language");
        if (!myLanguage) {
            myLanguage = consoleIo.ask("Please specify language code, e.g. `en`, `eng`, `en_US` etc.");
        }
        if (myLanguage.length < 2) {
             consoleIo.writeErrorMessages("Invalid language code. Valid is `en`, `eng`, `en_US` etc.");

            return CODE_ERROR;
        }
        
        auto somePaths = App.path("locales");
        if (arguments.hasKey("plugin")) {
            plugin = arguments.getString("plugin").camelize;
            somePaths = [Plugin.path(plugin) ~ "resources" ~ DIRECTORY_SEPARATOR ~ "locales" ~ DIRECTORY_SEPARATOR];
        }
        response = consoleIo.ask("What folder?", stripRight(somePaths[0], DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR);
        sourceFolder = stripRight(response, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
        targetFolder = sourceFolder ~ myLanguage ~ DIRECTORY_SEPARATOR;
        if (!isDir(targetFolder)) {
            mkdir(targetFolder, 0770, true);
        }
        size_t countFiles = 0;
        auto anIterator = new DirectoryIterator(sourceFolder);
        anIterator
            .filter!(fileInfo => fileInfo.isFile())
            .each!((fileInfo) {
                string filename = fileInfo.getFilename();
                string newFilename = fileInfo.getBasename(".pot") ~ ".po";

                auto content = file_get_contents(sourceFolder ~ filename);
                if (content == false) {
                    throw new DException("Cannot read file content of `%s`".format(sourceFolder ~ filename));
                }
                aConsoleIo.createFile(targetFolder ~ newFilename, content);
                countFiles++;
            });
         consoleIo.writeln("Generated " ~ countFiles ~ " PO files in " ~ targetFolder);

        return CODE_SUCCESS;
    }
    
    /**
     * Gets the option parser instance and configures it.
     * Params:
     * \UIM\Console\DConsoleOptionParser buildOptionParser  aParser The parser to update
     */
    DConsoleOptionParser buildOptionParser(DConsoleOptionParser aParser) {
         aParser.description("Initialize a language PO file from the POT file")
           .addOption("plugin", [
               "help": "The plugin to create a PO file in.",
               "short": "p",
           ])
           .addArgument("language", [
               "help": "Two-letter language code to create PO files for.",
           ]);

        return aParser;
    }
}
