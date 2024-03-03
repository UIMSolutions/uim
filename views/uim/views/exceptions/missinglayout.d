module uim.views.exceptions.missinglayout;

import uim.views;

@safe:

// Used when a layout file cannot be found.
class DMissingLayoutException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingLayout"));
    
    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        templateType("Layout");

        return true;
    }
}

mixin(ExceptionCalls!("MissingLayout"));
