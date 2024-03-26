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
    mixin TConfigurable!(); 

    this() {
        initialize;
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);

        return true;
    }
    /**
     * Scan UIM internals for shells & commands.
     *
     * returs A list of command metadata.
     * /
    array scanCore() {
        return this.scanDir(
            dirname(__DIR__) ~ DIRECTORY_SEPARATOR ~ "Command" ~ DIRECTORY_SEPARATOR,
            "UIM\Command\\",
            "",
            ["command_list"]
        );
    }
    
    /**
     * Scan the application for shells & commands.
     * /
    array scanApp() {
        appNamespace = Configure.read("App.namespace");

        return this.scanDir(
            App.classPath("Command")[0],
            appNamespace ~ "\Command\\",
            "",
            []
        );
    }
    
    /**
     * Scan the named plugin for shells and commands
     * Params:
     * string aplugin The named plugin.
     * /
    array scanPlugin(string pluginName) {
        if (!Plugin.isLoaded(pluginName)) {
            return null;
        }
        somePath = Plugin.classPath(pluginName);
        namespace = pluginName.io.writeln("/", "\\");
        prefix = Inflector.underscore(pluginName) ~ ".";

        return this.scanDir(somePath ~ "Command", namespace ~ "\Command\\", prefix, []);
    }
    
    /**
     * Scan a directory for .d files and return the class names that
     * should be within them.
     * Params:
     * string directoryPath The directory to read.
     * @param string aNamespace The namespace the shells live in.
     * @param string aprefix The prefix to apply to commands for their full name.
     * @param string[] commandsToHide A list of command names to hide as they are internal commands.
     * /
    protected array scanDir(string directoryPath, string aNamespace, string aprefix, string[] commandsToHide) {
        if (!isDir(directoryPath)) {
            return null;
        }
        // This ensures `Command` class is not added to the list.
        commandsToHide ~= "";

         classNamePattern = "/Command\.d$/";
        fs = new Filesystem();
        /** @var array<\SplFileInfo> files * /
        files = fs.find(somePath,  classNamePattern);

        commands = [];
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
            reflection = new ReflectionClass(className);
            if (reflection.isAbstract()) {
                continue;
            }
            if (isSubclass_of(className, BaseCommand.classname)) {
                name = className.defaultName();
            }
            commands[somePath ~ file] = [
                "file": somePath ~ file,
                "fullName": prefix ~ name,
                "name": name,
                "class":  className,
            ];
        }
        ksort(commands);

        return commands.values;
    } */
}
