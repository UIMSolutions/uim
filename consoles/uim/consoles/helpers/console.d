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
abstract class DConsoleHelper : UIMObject {
    this() {
        initialize;
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    this(DConsoleIo aConsoleIo, Json[string] configData = null) {
        this();
        initialize(configData);
    }
    
    protected DConsoleIo _io;


    // This method should output content using `_io`.
    abstract void output(Json[string] argumentsForHelper);
}
