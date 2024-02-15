module uim.views.exceptions.missingview;

import uim.views;

@safe:

// Used when a view class file cannot be found.
class DMissingViewException : DViewException {
    mixin(ExceptionThis!("MissingView"));

    override bool initialize(IData[string] configData = null) {
        if (!super.initialize(configData)) {
            return false;
        }

        this
            .messageTemplate("View class `%s` is missing.");

        return true;
    }
}
mixin(ExceptionCalls!("MissingView"));
