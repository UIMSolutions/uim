module uim.views.exceptions;

import uim.views;

@safe:

// Used when a template file for a cell cannot be found.
class MissingCellTemplateException : MissingTemplateException {
    protected string views;

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
        string views,
        string myfile,
        array mypaths = [],
        int mycode = null,
        Throwable myprevious = null
    ) {
        this.name = views;

        super(myfile, mypaths, mycode, myprevious);
    }
    
    /**
     * Get the passed in attributes
     */
    IData[string] getAttributes() {
        return [
            "name": this.name,
            "file": this.file,
            "paths": this.paths,
        ];
    }
}
