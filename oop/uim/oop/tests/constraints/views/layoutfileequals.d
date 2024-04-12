module oop.uim.oop.tests.constraints.views.layoutfileequal;
/**
 * LayoutFileEquals
 *
 * @internal
 */
class DLayoutFileEquals : DTemplateFileEquals {
    // Assertion message
    override string toString() {
        return "equals layout file `%s`".format(this.filename);
    }
}
