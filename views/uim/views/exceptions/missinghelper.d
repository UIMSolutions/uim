module uim.views.exceptions.missinghelper;

import uim.views;

@safe:

// Used when a helper cannot be found.
class DMissingHelperException : DViewException {
    mixin(ExceptionThis!("MissingHelper"));

    override bool initialize(IData[string] configData = null) {
        if (!super.initialize(configData)) {
            return false;
        }

        this
            .messageTemplate("Helper class `%s` could not be found.");

        return true;
    }
}
mixin(ExceptionCalls!("MissingHelper"));
