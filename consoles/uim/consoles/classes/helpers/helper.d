module uim.consoles.classes.helpers.helper;

import uim.consoles;

@safe:

/*
 * Base class for Helpers.
 *
 * Console Helpers allow you to package up reusable blocks
 * of Console output logic. For example creating tables,
 * progress bars or ascii art.
 */
abstract class DConsoleHelper {
    mixin TConfigurable; 

    this() {
        initialize;
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }
    
    /*
    protected IConsoleIo _io;

    /**
     * @param \UIM\Console\IConsoleIo aConsoleIo The ConsoleIo instance to use.
     * configData - The settings for this helper.
     * /
    this(IConsoleIo aConsoleIo, IData[string] configData = null) {
        this();
        initialize(configData);
    }

    /**
     * This method should output content using `_io`.
     * Params:
     * array someArguments The arguments for the helper.
     * /
    abstract void output(array someArguments);
    */ 
}
