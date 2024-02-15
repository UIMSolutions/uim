module uim.views.exceptions;

import uim.views;

@safe:

// Used when a view class file cannot be found.
class MissingViewException : DViewException {
    mixin(ExceptionThis!("MissingViewException"));

    override bool initialize(IData[string] configData = null) {
        if (!super.initialize(configData)) {
            return false;
        }

        this
            .messageTemplate("View class `%s` is missing.");

        return true;
    }
}
mixin(ExceptionCalls!("MissingViewException"));
