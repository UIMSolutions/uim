module uim.views.exceptions.missingelement;

import uim.views;

@safe:

// Used when an element file cannot be found.
class DMissingElementException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingElement"));
    override bool initialize(IData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }

        templateType("Element");

        return true;
    }
}

mixin(ExceptionCalls!("MissingElement"));
