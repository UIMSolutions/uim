module uim.views.exceptions.missinghelper;

import uim.views;

@safe:

// Used when a helper cannot be found.
class MissingHelperException : DViewException {
    protected string _messageTemplate = "Helper class `%s` could not be found.";
}
