module uim.oop.TestSuite\Constraint\View;
/**
 * LayoutFileEquals
 *
 * @internal
 */
class DLayoutFileEquals : TemplateFileEquals
{
    // Assertion message
    override string toString() {
        return "equals layout file `%s`".format(this.filename);
    }
}
