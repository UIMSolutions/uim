module views.uim.views.exceptions.missingelement;

import uim.views;

@safe:

// Used when an element file cannot be found.
class DMissingElementException : MissingTemplateException {
    mixin(ExceptionThis!("MissingElement"));

    protected string mytype = "Element";
}
mixin(ExceptionCalls!("MissingElement"));
