module uim.consoles;

import uim.consoles;

@safe:

/*
 * Base class for Helpers.
 *
 * Console Helpers allow you to package up reusable blocks
 * of Console output logic. For example creating tables,
 * progress bars or ascii art.
 */
abstract class Helper {
    mixin InstanceConfigTemplate();

    // Default config for this helper.
    protected IData[string] _defaultConfigData;

    protected ConsoleIo _io;

    /**
     * @param \UIM\Console\ConsoleIo aConsoleIo The ConsoleIo instance to use.
     * configData - The settings for this helper.
     */
    this() {
        initialize;
    }
    this(ConsoleIo aConsoleIo, IData[string] configData = null) {
        this();
       _io = aConsoleIo;
        this.setConfig(configData);
    }
    bool initialize(IData[string] initData = null) {
       _defaultConfigData = Json.emptyObject;

       _defaultConfigData.copy(myConfiguration)
    }
    
    /**
     * This method should output content using `_io`.
     * Params:
     * array someArguments The arguments for the helper.
     */
    abstract void output(array someArguments);
}
