module uim.oop.consoles.console;

import uim.oop;
@safe:

class DConsole : UIMObject, IConsole {
    mixin(ConsoleThis!(""));
/*    mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}