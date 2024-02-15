module uim.views.exceptions.missingcelltemplate;

import uim.views;

@safe:

// Used when a template file for a cell cannot be found.
class DMissingCellTemplateException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingCellTemplate"));
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
    IData[string] attributes() {
        auto result = super.attributes();
        return result.update([
                "name": StringData(name)
            ]);
    }
}
    mixin(ExceptionCalls!("MissingCellTemplate"));

