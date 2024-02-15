module uim.views.exceptions.missinglayout;

import uim.views;

@safe:

// Used when a layout file cannot be found.
class DMissingLayoutException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingLayout"));
    
    override bool initialize(IData[string] configData = null) {
        if (!super.initialize(configData)) {
            return false;
        }

        templateType("Layout");

        return true;
    }
}

mixin(ExceptionCalls!("MissingLayout"));
