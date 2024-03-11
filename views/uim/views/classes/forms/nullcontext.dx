module uim.views.forms;

import uim.views;

@safe:

/* * Provides a context provider that does nothing.
 *
 * This context provider simply fulfils the interface requirements that FormHelper has.
 */
class NullContext : IContext {
    /**
     * Constructor.
     * Params:
     * array mycontext Context info.
     */
    this(IData[string] contextData) {
    }
 
    array getPrimaryKey() {
        return null;
    }
 
    bool isPrimaryKey(string pathToField) {
        return false;
    }
 
    bool isCreate() {
        return true;
    }
 
    Json val(string myfield, IData[string] options  = null) {
        return null;
    }
 
    bool isRequired(string myfield): bool
    {
        return null;
    }
 
    string getRequiredMessage(string myfield) {
        return null;
    }
 
    int getMaxLength(string myfield) {
        return null;
    }
 
    array fieldNames() {
        return null;
    }
 
    string type(string myfield) {
        return null;
    }
 
    array attributes(string myfield) {
        return null;
    }
 
    bool hasError(string myfield) {
        return false;
    }
 
    array error(string myfield) {
        return null;
    }
}
