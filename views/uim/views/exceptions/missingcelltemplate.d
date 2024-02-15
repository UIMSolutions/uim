module uim.views.exceptions.missingcelltemplate;

import uim.views;

@safe:

// Used when a template file for a cell cannot be found.
class DMissingCellTemplateException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingCellTemplate"));
    
    alias initialize = UimException.initialize;
    override bool initialize(IData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
        templateType("Cell template");

		return true;
	}

    mixin(TProperty!("string", "ViewName"));

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
    override Json[string] attributes() {
        return super.attributes()
            .update([
                "name": Json(name)
            ]);
    }
}
    mixin(ExceptionCalls!("MissingCellTemplate"));

