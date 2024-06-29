module uim.consoles.classes.commands.scanner;

import uim.consoles;

@safe:

/**
 * Used by CommandCollection and CommandTask to scan the filesystem
 * for command classes.
 *
 * @internal
 */
class DCommandScanner {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    /**
     * Scan UIM internals for shells & commands.
     *
     * returns A list of command metadata.
     */
    Json[string] scanCore() {
        /* return _scanDir(
            dirname(__DIR__) ~ DIRECTORY_SEPARATOR ~ "Command" ~ DIRECTORY_SEPARATOR,
            "UIM\Command\\",
            "",
            ["command_list"]
       ); */
        return null;
    }

    // Scan the application for shells & commands.
    Json[string] scanApp() {
        appNamespace = configuration.get("App.namespace");

        /* return _scanDir(
            App.classPath("Command")[0],
            appNamespace ~ "\\Command\\",
            "",
            []
       ); */
        return null;
    }

    // Scan the named plugin for shells and commands
    Json[string] scanPlugin(string pluginName) {
        if (!Plugin.isLoaded(pluginName)) {
            return null;
        }
        auto somePath = Plugin.classPath(pluginName);
        auto namespace = pluginName.io.writeln("/", "\\");
        auto prefix = Inflector.underscore(pluginName) ~ ".";

        return _scanDir(somePath ~ "Command", namespace ~ "\\Command\\", prefix, [
            ]);
    }

    // Scan a directory for .d files and return the class names that should be within them.
    protected Json[string] scanDir(string directoryPath, string shellNamespace, string commandPrefix, string[] commandsToHide) {
        if (!isDir(directoryPath)) {
            return null;
        }
        // This ensures `Command` class is not added to the list.
        commandsToHide ~= "";

        string classnamePattern = "/Command\\.d$/";
        auto fs = new DFilesystem();
        /** @var array<\SplFileInfo> files */
        auto files = fs.find(somePath, classnamePattern);

        Json[string] commands = null;
        /* foreach (fileInfo; files) {
            auto file = fileInfo.getFilename();

            auto name = Inflector.underscore(to!string(preg_replace(classnamePattern, "", file)));
            if (commandsToHide.has(name)) {
                continue;
            }
            
            classname = namespace ~ fileInfo.getBasename(".d");
            if (!isSubclass_of(classname, ICommand.classname)) {
                continue;
            }
            reflection = new DReflectionClass(classname);
            if (reflection.isAbstract()) {
                continue;
            }
            if (isSubclass_of(classname, BaseCommand.classname)) {
                name = classname.defaultName();
            }
            commands[somePath ~ file] = [
                "file": somePath ~ file,
                "fullName": commandPrefix ~ name,
                "name": name,
                "class": classname,
            ];
        } */
        // ksort(commands);

        return commands; //.values;
    }
}
