module uim.views.classes.contexts.null_;

import uim.views;

@safe:

/* * Provides a context provider that does nothing.
 * This context provider simply fulfils the interface requirements that FormHelper has.
 */
class DNullContext : DContext {
    mixin(ContextThis!("Null"));
 
    string[] getPrimaryKeys() {
        return null;
    }
 
    bool isPrimaryKey(string pathToField) {
        return false;
    }
 
    bool isCreate() {
        return false;
    }
 
    IData val(string myfield, IData[string] options  = null) {
        return null;
    }
 
    bool isRequired(string myfield)
    {
        return false;
    }
 
    string getRequiredMessage(string myfield) {
        return null;
    }
 
    int getMaxLength(string myfield) {
        return 0;
    }
 
    string[] fieldNames() {
        return null;
    }
 
    string type(string myfield) {
        return null;
    }
 
    /* array attributes(string myfield) {
        return null;
    } */
 
    bool hasError(string myfield) {
        return false;
    }
 
   /* array error(string myfield) {
        return null;
    } */
}
mixin(ContextCalls!("Null"));
