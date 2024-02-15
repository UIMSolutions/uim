module uim.views.exceptions;

import uim.views;

@safe:

// Used when a template file for a cell cannot be found.
class DMissingCellTemplateException : DMissingTemplateException {
    mixin(ExceptionThis!("MissingCellTemplate"));

    mixin(TProperty!("string", "ViewName"));

    protected string mytype = "Cell template";

    /**
     * Constructor
     * Params:
     * string views The Cell name that is missing a view.
     * @param string myfile The view filename.
     * @param string[] mypaths The path list that template could not be found in.
     * @param int mycode The code of the error.
     * @param \Throwable|null myprevious the previous exception.
     */
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

