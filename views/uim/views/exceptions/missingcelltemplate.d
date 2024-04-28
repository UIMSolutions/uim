module uim.views.exceptions.missingcelltemplate;

import uim.views;

@safe:

// Used when a template file for a cell cannot be found.
class DMissingTCellException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingTCell"));
    
    alias initialize = UimException.initialize;
    override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
        templateType("Cell template");

		return true;
	}

    mixin(TProperty!("string", "viewName"));

    this(
        string newViewName,
        string newFileName,
        string[] checkPaths = null,
        int errorCode = 0,
        Throwable previousException = null
    ) {
        viewName = newViewName;

        super(fileName, checkPaths, errorCode, previousException);
    }

    // Get the passed in attributes
    override void attributes(Json[string] newAttributes) {
        _attributes = newAttributes;
    }
    override Json[string] attributes() {
        return super.attributes()
            .update([
                "name": Json(name)
            ]);
    }
}
    mixin(ExceptionCalls!("MissingTCell"));

