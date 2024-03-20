module uim.cake.TestSuite\Constraint\View;

import uim.cake;

@safe:
/**
 * TemplateFileEquals
 *
 * @internal
 */
class TemplateFileEquals : Constraint {
    protected string afilename;

    /**
     * Constructor
     * Params:
     * string afilename Template file name
     */
    this(string templateFilename) {
        this.filename = templateFilename;
    }
    
    /**
     * Checks assertion
     * Params:
     * Json other Expected filename
     */
   bool matches(Json expectedOther) {
        return this.filename.has(other);
    }
    
    // Assertion message
    override string toString() {
        return "equals template file `%s`".format(this.filename);
    }
}
