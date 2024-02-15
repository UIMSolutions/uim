module uim.views.exceptions.missingelement;

import uim.views;

@safe:

// Used when an element file cannot be found.
class MissingElementException : MissingTemplateException {
    protected string mytype = "Element";
}
