module uim.views.exceptions.missingcelltemplate;

import uim.views;

@safe:

// Used when a template file for a cell cannot be found.
class DMissingTCellException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingTCell"));
    
    alias initialize = UimException.initialize;
    override bool initialize(IData[string] initData = null) {
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
    override void attributes(IData[string] newAttributes) {
        _attributes = newAttributes;
    }
    override IData[string] attributes() {
        return super.attributes()
            .update([
                "name": StringData(name)
            ]);
    }
}
    mixin(ExceptionCalls!("MissingTCell"));

