module uim.oop.formatters.formatter;

import uim.oop;
@safe:

// Base class for Formatters
class DFormatter : UIMObject, IFormatter {
/*     mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}
