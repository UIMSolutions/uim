module uim.views.classes.contexts.null_;

import uim.views;

@safe:

/* * Provides a context provider that does nothing.
 * This context provider simply fulfils the interface requirements that FormHelper has.
 */
class DNullContext : DContext {
    mixin(ContextThis!("Null"));
 
    string[] primaryKeys() {
        return null;
    }
 
    bool isPrimaryKey(string pathToField) {
        return false;
    }
 
    bool isCreate() {
        return false;
    }
 
    Json val(string fieldName, Json[string] options  = null) {
        return Json(null);
    }
 
    bool isRequired(string fieldName) {
        return false;
    }
 
    string getRequiredMessage(string fieldName) {
        return null;
    }
 
    int getMaxLength(string fieldName) {
        return 0;
    }
 
    override string[] fieldNames() {
        return null;
    }
 
    string type(string fieldName) {
        return null;
    }
 
    /* Json[string] attributes(string myfield) {
        return null;
    } */
 
    bool hasError(string myfield) {
        return false;
    }
 
   /* Json[string] error(string myfield) {
        return null;
    } */
}
mixin(ContextCalls!("Null"));
