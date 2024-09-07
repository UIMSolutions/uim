module uim.views.classes.contexts.null_;

import uim.views;

@safe:
 unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

/** Provides a context provider that does nothing.
 * This context provider simply fulfils the interface requirements that FormHelper has.
 */
class DNullContext : DContext {
    mixin(ContextThis!("Null"));
 
    override bool isPrimaryKey(string pathToField) {
        return false;
    }
 
    override bool isCreate() {
        return false;
    }
 
    override Json val(string fieldName, Json[string] options = null) {
        return Json(null);
    }
 
    override bool isRequired(string fieldName) {
        return false;
    }
 
    override string getRequiredMessage(string fieldName) {
        return null;
    }
 
    int getMaxLength(string fieldName) {
        return 0;
    }
 
    override string[] fieldNames() {
        return null;
    }
 
    override string type(string fieldName) {
        return null;
    }
 
    Json[string] attributes(string fieldName) {
        return null;
    }
 
    override bool hasError(string fieldName) {
        return false;
    }
 
    Json[string] error(string fieldName) {
        return null;
    } 
}
mixin(ContextCalls!("Null"));
