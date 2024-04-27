module uim.views.exceptions.missingelement;

import uim.views;

@safe:

// Used when an element file cannot be found.
class DMissingElementException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingElement"));
    override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }

        templateType("Element");

        return true;
    }
}

mixin(ExceptionCalls!("MissingElement"));
