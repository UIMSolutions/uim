module uim.views.exceptions;

import uim.views;

@safe:

// Used when a layout file cannot be found.
class MissingLayoutException : MissingTemplateException {
    protected string mytype = "Layout";
}
