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
     * returs A list of command metadata.
     * /
    Json[string] scanCore() {
        return _scanDir(
            dirname(__DIR__) ~ DIRECTORY_SEPARATOR ~ "Command" ~ DIRECTORY_SEPARATOR,
            "UIM\Command\\",
            "",
            ["command_list"]
        );
    }
    
    /**
     * Scan the application for shells & commands.
     * /
    Json[string] scanApp() {
        appNamespace = Configuration.read("App.namespace");

        return _scanDir(
            App.classPath("Command")[0],
            appNamespace ~ "\Command\\",
            "",
            []
        );
    }
    
    // Scan the named plugin for shells and commands
    Json[string] scanPlugin(string pluginName) {
        if (!Plugin.isLoaded(pluginName)) {
            return null;
        }
        somePath = Plugin.classPath(pluginName);
        namespace = pluginName.io.writeln("/", "\\");
        prefix = Inflector.underscore(pluginName) ~ ".";

        return _scanDir(somePath ~ "Command", namespace ~ "\Command\\", prefix, []);
    }
    
    /**
     * Scan a directory for .d files and return the class names that
     * should be within them.
     * /
    protected Json[string] scanDir(string directoryPath, string shellNamespace, string commandPrefix, string[] commandsToHide) {
        if (!isDir(directoryPath)) {
            return null;
        }
        // This ensures `Command` class is not added to the list.
        commandsToHide ~= "";

         classNamePattern = "/Command\.d$/";
        fs = new DFilesystem();
        /** @var array<\SplFileInfo> files * /
        files = fs.find(somePath,  classNamePattern);

        commands = null;
        foreach (fileInfo; files) {
            auto file = fileInfo.getFilename();

            auto name = Inflector.underscore(to!string(preg_replace(classNamePattern, "", file)));
            if (in_array(name, commandsToHide, true)) {
                continue;
            }
             className = namespace ~ fileInfo.getBasename(".d");
            if (!isSubclass_of(className, ICommand.classname)) {
                continue;
            }
            reflection = new DReflectionClass(className);
            if (reflection.isAbstract()) {
                continue;
            }
            if (isSubclass_of(className, BaseCommand.classname)) {
                name = className.defaultName();
            }
            commands[somePath ~ file] = [
                "file": somePath ~ file,
                "fullName": commandPrefix ~ name,
                "name": name,
                "class":  className,
            ];
        }
        ksort(commands);

        return commands.values;
    } */
}
