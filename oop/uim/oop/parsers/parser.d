module uim.oop.parsers.parser;

import uim.oop;
@safe:

// Base class for parsers
class DParser : UIMObject, IParser {
/*    mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}
