module uim.consoles.helpers.console;

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
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }
    
    protected DConsoleIo _io;

    this(DConsoleIo aConsoleIo, Json[string] configData = null) {
        this();
        initialize(configData);
    }

    // This method should output content using `_io`.
    abstract void output(Json[string] argumentsForHelper);
}
