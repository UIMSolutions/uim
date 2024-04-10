module consoles.uim.consoles.tests.constraints.contents.empty;

import uim.consoles;

@safe:

/* * ContentsEmpty
 *
 * @internal
 */
class DContentsEmpty : DContentsBase {
    /**
     * Checks if contents are empty
     * Params:
     * IData other Expected
     */
   bool matches(IData other) {
        return this.contents == "";
    }
    
    // Assertion message
    string toString() {
        return "%s is empty".format(this.output);
    }
    
    /**
     * Overwrites the descriptions so we can remove the automatic "expected" message
     * Params:
     * IData other Value
     */
    protected string failureDescription(IData other) {
        return this.toString();
    }
}
